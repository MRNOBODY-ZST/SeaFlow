import gradio as gr
import mysql.connector
import pandas as pd
from datetime import datetime, date, timedelta
import plotly.express as px
import plotly.graph_objects as go
from plotly.subplots import make_subplots
from typing import Optional
from sqlalchemy import create_engine
import warnings
import functools
import time
from threading import Lock

# 忽略pandas的SQLAlchemy警告
warnings.filterwarnings("ignore", message="pandas only supports SQLAlchemy connectable")

# 缓存机制
cache_lock = Lock()
chart_cache = {}
stats_cache = {}
CACHE_TIMEOUT = 300  # 5分钟缓存

def cache_with_timeout(timeout=300):
    """带超时的缓存装饰器"""
    def decorator(func):
        @functools.wraps(func)
        def wrapper(*args, **kwargs):
            cache_key = f"{func.__name__}_{hash(str(args) + str(kwargs))}"
            current_time = time.time()
            
            with cache_lock:
                if cache_key in chart_cache:
                    result, timestamp = chart_cache[cache_key]
                    if current_time - timestamp < timeout:
                        return result
                
                # 缓存过期或不存在，重新计算
                result = func(*args, **kwargs)
                chart_cache[cache_key] = (result, current_time)
                return result
        return wrapper
    return decorator

class ShippingDatabaseManager:
    def __init__(self, host="localhost", user="shipping_management_system_admin", password="3503e8c606684cd2bdc47dfd008a4486", database="shipping_management_system"):
        self.connection_params = {
            "host": host,
            "user": user,
            "password": password,
            "database": database
        }
        # 创建SQLAlchemy引擎用于pandas
        self.engine = create_engine(
            f"mysql+mysqlconnector://{user}:{password}@{host}/{database}",
            pool_pre_ping=True,
            pool_recycle=300
        )
    
    def get_connection(self):
        """创建数据库连接"""
        try:
            return mysql.connector.connect(**self.connection_params)
        except mysql.connector.Error as e:
            raise Exception(f"数据库连接失败: {e}")
    
    def execute_query(self, query: str, params: Optional[tuple] = None, fetch: bool = True):
        """执行SQL查询并返回结果"""
        try:
            conn = self.get_connection()
            cursor = conn.cursor(dictionary=True)
            cursor.execute(query, params or ())
            
            if fetch:
                result = cursor.fetchall()
                cursor.close()
                conn.close()
                return result
            else:
                conn.commit()
                cursor.close()
                conn.close()
                return True
        except mysql.connector.Error as e:
            return f"数据库错误: {e}"
    
    def get_dataframe(self, query: str, params: Optional[tuple] = None) -> pd.DataFrame:
        """执行查询并返回DataFrame"""
        try:
            # 使用SQLAlchemy引擎来避免警告
            df = pd.read_sql(query, self.engine, params=params)
            return df
        except Exception as e:
            return pd.DataFrame({"错误": [str(e)]})

# 初始化数据库管理器
db_manager = ShippingDatabaseManager()

# 数据查询函数
def get_companies():
    """获取所有船运公司"""
    query = """
    SELECT company_id as '公司ID', company_name as '公司名称', 
           registration_country as '注册国家', contact_phone as '联系电话', 
           contact_email as '邮箱', fleet_size as '船队规模', 
           established_year as '成立年份'
    FROM shipping_companies 
    ORDER BY company_name
    """
    return db_manager.get_dataframe(query)

def get_ships():
    """获取所有船只信息"""
    query = """
    SELECT s.ship_id as '船只ID', s.ship_name as '船只名称', 
           CASE s.ship_type 
               WHEN 'cargo_ship' THEN '货船'
               WHEN 'passenger_ship' THEN '客船'
               WHEN 'container_ship' THEN '集装箱船'
               WHEN 'tanker' THEN '油轮'
               WHEN 'bulk_carrier' THEN '散货船'
               ELSE s.ship_type
           END as '船只类型',
           s.deadweight_tonnage as '载重吨位', s.length as '长度(米)', 
           s.width as '宽度(米)', s.build_year as '建造年份',
           CASE s.current_status
               WHEN 'in_port' THEN '在港'
               WHEN 'sailing' THEN '航行中'
               WHEN 'under_maintenance' THEN '维修中'
               WHEN 'out_of_service' THEN '停用'
               ELSE s.current_status
           END as '当前状态',
           sc.company_name as '所属公司'
    FROM ships s
    JOIN shipping_companies sc ON s.company_id = sc.company_id
    ORDER BY s.ship_name
    """
    return db_manager.get_dataframe(query)

def get_ports():
    """获取所有港口"""
    query = """
    SELECT port_id as '港口ID', port_name as '港口名称', city as '城市', 
           country as '国家', 
           CASE port_type
               WHEN 'cargo_port' THEN '货运港'
               WHEN 'passenger_port' THEN '客运港'
               WHEN 'multi_purpose' THEN '多用途港'
               WHEN 'specialized_port' THEN '专业港'
               ELSE port_type
           END as '港口类型',
           berth_count as '泊位数量', max_draft as '最大吃水'
    FROM ports 
    ORDER BY port_name
    """
    return db_manager.get_dataframe(query)

def get_customers():
    """获取所有客户"""
    query = """
    SELECT customer_id as '客户ID', company_name as '公司名称', 
           contact_person as '联系人', phone as '电话', email as '邮箱',
           CASE customer_type
               WHEN 'shipper' THEN '发货人'
               WHEN 'consignee' THEN '收货人'
               WHEN 'freight_forwarder' THEN '货代'
               WHEN 'comprehensive' THEN '综合'
               ELSE customer_type
           END as '客户类型',
           credit_rating as '信用等级', registration_date as '注册日期'
    FROM customers 
    ORDER BY company_name
    """
    return db_manager.get_dataframe(query)

def get_orders():
    """获取运输订单详情"""
    query = """
    SELECT order_id as '订单ID', order_number as '订单编号',
           shipper_name as '发货人', consignee_name as '收货人',
           origin_port as '起始港口', destination_port as '目的港口',
           CASE order_status
               WHEN 'pending' THEN '待处理'
               WHEN 'confirmed' THEN '已确认'
               WHEN 'ship_assigned' THEN '已分配船只'
               WHEN 'in_transit' THEN '运输中'
               WHEN 'arrived' THEN '已到达'
               WHEN 'completed' THEN '已完成'
               WHEN 'cancelled' THEN '已取消'
               ELSE order_status
           END as '订单状态',
           total_weight as '总重量', total_volume as '总体积',
           freight_amount as '运费金额', order_date as '订单日期',
           required_delivery_date as '要求交货日期'
    FROM order_details_view 
    ORDER BY order_date DESC
    """
    return db_manager.get_dataframe(query)

def get_voyages():
    """获取航次信息"""
    query = """
    SELECT v.voyage_id as '航次ID', v.voyage_number as '航次编号', 
           s.ship_name as '船只名称', 
           op.port_name as '起始港口', dp.port_name as '目的港口',
           v.departure_time as '出发时间', v.arrival_time as '到达时间', 
           CASE v.voyage_status
               WHEN 'planned' THEN '计划中'
               WHEN 'in_progress' THEN '进行中'
               WHEN 'completed' THEN '已完成'
               WHEN 'cancelled' THEN '已取消'
               ELSE v.voyage_status
           END as '航次状态',
           v.distance_nautical_miles as '距离(海里)', 
           v.fuel_consumption as '燃料消耗'
    FROM voyages v
    JOIN ships s ON v.ship_id = s.ship_id
    JOIN ports op ON v.origin_port_id = op.port_id
    JOIN ports dp ON v.destination_port_id = dp.port_id
    ORDER BY v.departure_time DESC
    """
    return db_manager.get_dataframe(query)

# 添加功能函数
def add_shipping_company(company_name, country, phone, email, address, established_year):
    """添加船运公司"""
    try:
        if not company_name or not country:
            return "请填写公司名称和注册国家"
        
        query = """
        INSERT INTO shipping_companies 
        (company_name, registration_country, contact_phone, contact_email, address, established_year)
        VALUES (%s, %s, %s, %s, %s, %s)
        """
        result = db_manager.execute_query(query, 
            (company_name, country, phone, email, address, int(established_year) if established_year else None), 
            fetch=False)
        
        if result is True:
            clear_cache()
            return "船运公司添加成功！"
        else:
            return f"添加失败: {result}"
    except Exception as e:
        return f"错误: {str(e)}"

def add_port(port_name, city, country, port_type, berth_count, max_draft, latitude, longitude):
    """添加港口"""
    try:
        if not all([port_name, city, country, port_type, berth_count, max_draft]):
            return "请填写所有必填字段"
        
        query = """
        INSERT INTO ports 
        (port_name, city, country, port_type, berth_count, max_draft, latitude, longitude)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
        """
        result = db_manager.execute_query(query, 
            (port_name, city, country, port_type, int(berth_count), 
             float(max_draft), float(latitude) if latitude else None, 
             float(longitude) if longitude else None), 
            fetch=False)
        
        if result is True:
            clear_cache()
            return "港口添加成功！"
        else:
            return f"添加失败: {result}"
    except Exception as e:
        return f"错误: {str(e)}"

def add_ship(ship_name, ship_type, tonnage, length, width, build_year, company_id):
    """添加船只"""
    try:
        if not all([ship_name, ship_type, tonnage, length, width, build_year, company_id]):
            return "请填写所有必填字段"
        
        query = """
        INSERT INTO ships 
        (ship_name, ship_type, deadweight_tonnage, length, width, build_year, company_id)
        VALUES (%s, %s, %s, %s, %s, %s, %s)
        """
        result = db_manager.execute_query(query, 
            (ship_name, ship_type, float(tonnage), float(length), 
             float(width), int(build_year), int(company_id)), 
            fetch=False)
        
        if result is True:
            clear_cache()
            return "船只添加成功！"
        else:
            return f"添加失败: {result}"
    except Exception as e:
        return f"错误: {str(e)}"

def add_customer(company_name, contact_person, phone, email, address, customer_type, credit_rating):
    """添加客户"""
    try:
        if not all([company_name, contact_person, customer_type, credit_rating]):
            return "请填写必填字段：公司名称、联系人、客户类型、信用等级"
        
        query = """
        INSERT INTO customers 
        (company_name, contact_person, phone, email, address, customer_type, credit_rating, registration_date)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
        """
        result = db_manager.execute_query(query, 
            (company_name, contact_person, phone, email, address, 
             customer_type, credit_rating, date.today()), 
            fetch=False)
        
        if result is True:
            clear_cache()
            return "客户添加成功！"
        else:
            return f"添加失败: {result}"
    except Exception as e:
        return f"错误: {str(e)}"

# 订单和航次创建函数
def create_new_order(shipper_id: str, consignee_id: str, origin_port_id: str, 
                    destination_port_id: str, total_weight: str, total_volume: str,
                    total_value: str, required_delivery_date: str):
    """创建新运输订单"""
    try:
        # 验证输入
        if not all([shipper_id, consignee_id, origin_port_id, destination_port_id, 
                   total_weight, total_volume, required_delivery_date]):
            return "请填写所有必填字段"
        
        shipper_id_int = int(shipper_id)
        consignee_id_int = int(consignee_id)
        origin_port_id_int = int(origin_port_id)
        destination_port_id_int = int(destination_port_id)
        total_weight_float = float(total_weight)
        total_volume_float = float(total_volume)
        total_value_float = float(total_value) if total_value else 0
        
        # 解析日期
        delivery_date = datetime.strptime(required_delivery_date, "%Y-%m-%d").date()
        
        # 调用存储过程
        conn = db_manager.get_connection()
        cursor = conn.cursor()
        
        # 调用存储过程
        args = [shipper_id_int, consignee_id_int, origin_port_id_int, 
                destination_port_id_int, total_weight_float, total_volume_float,
                total_value_float, delivery_date, 0, '']
        
        cursor.callproc('CreateTransportOrder', args)
        
        # 获取输出参数
        cursor.execute("SELECT @_CreateTransportOrder_8, @_CreateTransportOrder_9")
        result = cursor.fetchone()
        order_id, order_number = result
        
        conn.commit()
        cursor.close()
        conn.close()
        
        # 清除缓存以显示最新数据
        clear_cache()
        
        return f"订单创建成功！\n订单ID: {order_id}\n订单编号: {order_number}"
        
    except ValueError as e:
        return f"输入验证错误: 请检查输入值格式"
    except Exception as e:
        return f"创建订单失败: {str(e)}"

def assign_ship_to_order(order_id: str, ship_id: str):
    """为订单分配船只"""
    try:
        if not order_id or not ship_id:
            return "请输入订单ID和船只ID"
            
        order_id_int = int(order_id)
        ship_id_int = int(ship_id)
        
        conn = db_manager.get_connection()
        cursor = conn.cursor()
        
        # 调用存储过程
        args = [order_id_int, ship_id_int, False, '']
        cursor.callproc('AssignShipToOrder', args)
        
        # 获取输出参数
        cursor.execute("SELECT @_AssignShipToOrder_2, @_AssignShipToOrder_3")
        result = cursor.fetchone()
        success, message = result
        
        conn.commit()
        cursor.close()
        conn.close()
        
        # 清除缓存
        clear_cache()
        
        if success:
            return f"{message}"
        else:
            return f"{message}"
            
    except ValueError:
        return "无效输入: 请输入有效的订单ID和船只ID"
    except Exception as e:
        return f"分配失败: {str(e)}"

def create_new_voyage(ship_id: str, origin_port_id: str, destination_port_id: str,
                     departure_time: str, estimated_arrival: str):
    """创建新航次"""
    try:
        if not all([ship_id, origin_port_id, destination_port_id, departure_time]):
            return "请填写所有必填字段"
        
        ship_id_int = int(ship_id)
        origin_port_id_int = int(origin_port_id)
        destination_port_id_int = int(destination_port_id)
        
        # 解析时间
        departure_dt = datetime.strptime(departure_time, "%Y-%m-%d %H:%M")
        arrival_dt = None
        if estimated_arrival:
            arrival_dt = datetime.strptime(estimated_arrival, "%Y-%m-%d %H:%M")
        
        # 生成航次编号
        voyage_number = f"VOY{datetime.now().strftime('%Y%m%d')}{ship_id_int:03d}"
        
        # 插入航次记录
        query = """
        INSERT INTO voyages (voyage_number, ship_id, origin_port_id, destination_port_id, 
                           departure_time, arrival_time, voyage_status)
        VALUES (%s, %s, %s, %s, %s, %s, 'planned')
        """
        
        result = db_manager.execute_query(query, 
            (voyage_number, ship_id_int, origin_port_id_int, destination_port_id_int,
             departure_dt, arrival_dt), fetch=False)
        
        if result is True:
            # 更新船只状态为航行中
            update_query = "UPDATE ships SET current_status = 'sailing' WHERE ship_id = %s"
            db_manager.execute_query(update_query, (ship_id_int,), fetch=False)
            
            # 清除缓存
            clear_cache()
            
            return f"航次创建成功！\n航次编号: {voyage_number}"
        else:
            return f"创建失败: {result}"
            
    except ValueError:
        return "输入格式错误: 请检查日期时间格式 (YYYY-MM-DD HH:MM)"
    except Exception as e:
        return f"创建航次失败: {str(e)}"

# 优化的统计查询函数
@cache_with_timeout(CACHE_TIMEOUT)
def get_all_statistics():
    """一次性获取所有统计数据"""
    try:
        # 使用单个查询获取多个统计信息
        query = """
        SELECT 
            (SELECT COUNT(*) FROM transport_orders) as total_orders,
            (SELECT COUNT(*) FROM voyages WHERE voyage_status = 'in_progress') as active_voyages,
            (SELECT COUNT(*) FROM ships) as total_ships,
            (SELECT COUNT(*) FROM ports) as total_ports,
            (SELECT COALESCE(SUM(freight_amount), 0) FROM transport_orders 
             WHERE YEAR(order_date) = YEAR(CURDATE()) AND MONTH(order_date) = MONTH(CURDATE())) as monthly_revenue,
            (SELECT COUNT(*) FROM transport_orders WHERE order_status = 'completed') as completed_orders,
            (SELECT COUNT(*) FROM transport_orders WHERE order_status = 'in_transit') as in_transit_orders
        """
        result = db_manager.execute_query(query)
        return result[0] if result else {}
    except Exception as e:
        return {}

@cache_with_timeout(CACHE_TIMEOUT)
def create_monthly_orders_chart():
    """优化的月度订单统计图表"""
    try:
        query = """
        SELECT DATE_FORMAT(order_date, '%Y-%m') as month, 
               COUNT(*) as order_count,
               COALESCE(SUM(freight_amount), 0) as revenue
        FROM transport_orders 
        WHERE order_date >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH)
        GROUP BY DATE_FORMAT(order_date, '%Y-%m')
        ORDER BY month
        """
        df = db_manager.get_dataframe(query)
        
        if df.empty or 'month' not in df.columns:
            return go.Figure().add_annotation(text="暂无数据", x=0.5, y=0.5)
        
        fig = make_subplots(specs=[[{"secondary_y": True}]])
        
        fig.add_trace(
            go.Bar(x=df['month'], y=df['order_count'], name="订单数量", marker_color='lightblue'),
            secondary_y=False,
        )
        
        fig.add_trace(
            go.Scatter(x=df['month'], y=df['revenue'], name="收入", mode='lines+markers', 
                      line=dict(color='red', width=3)),
            secondary_y=True,
        )
        
        fig.update_xaxes(title_text="月份")
        fig.update_yaxes(title_text="订单数量", secondary_y=False)
        fig.update_yaxes(title_text="收入 ($)", secondary_y=True)
        fig.update_layout(title_text="月度订单量与收入统计", height=400)
        
        return fig
    except Exception as e:
        return go.Figure().add_annotation(text=f"图表生成错误: {str(e)}", x=0.5, y=0.5)

@cache_with_timeout(CACHE_TIMEOUT)
def create_ship_status_chart():
    """优化的船只状态分布图"""
    try:
        query = """
        SELECT current_status, COUNT(*) as count
        FROM ships 
        GROUP BY current_status
        ORDER BY count DESC
        """
        df = db_manager.get_dataframe(query)
        
        if df.empty:
            return go.Figure().add_annotation(text="暂无船只数据", x=0.5, y=0.5)
        
        # 状态映射
        status_map = {
            'in_port': '在港',
            'sailing': '航行中',
            'under_maintenance': '维修中',
            'out_of_service': '停用'
        }
        df['status_cn'] = df['current_status'].map(status_map).fillna(df['current_status'])
        
        fig = px.pie(df, values='count', names='status_cn', title='船只状态分布')
        fig.update_layout(height=400)
        return fig
    except Exception as e:
        return go.Figure().add_annotation(text=f"图表生成错误: {str(e)}", x=0.5, y=0.5)

@cache_with_timeout(CACHE_TIMEOUT)
def create_port_business_chart():
    """优化的港口业务量统计图"""
    try:
        # 简化查询，避免复杂JOIN
        query = """
        SELECT p.port_name, p.city,
               (SELECT COUNT(*) FROM transport_orders WHERE origin_port_id = p.port_id) as outbound_orders,
               (SELECT COUNT(*) FROM transport_orders WHERE destination_port_id = p.port_id) as inbound_orders
        FROM ports p
        HAVING (outbound_orders + inbound_orders) > 0
        ORDER BY (outbound_orders + inbound_orders) DESC
        LIMIT 10
        """
        df = db_manager.get_dataframe(query)
        
        if df.empty:
            return go.Figure().add_annotation(text="暂无港口业务数据", x=0.5, y=0.5)
        
        df['港口'] = df['port_name'] + ' (' + df['city'] + ')'
        
        fig = go.Figure()
        fig.add_trace(go.Bar(
            name='出港订单',
            x=df['港口'],
            y=df['outbound_orders'],
            marker_color='lightcoral'
        ))
        fig.add_trace(go.Bar(
            name='进港订单',
            x=df['港口'],
            y=df['inbound_orders'],
            marker_color='lightblue'
        ))
        
        fig.update_layout(
            title='港口业务量统计（前10名）',
            xaxis_title='港口',
            yaxis_title='订单数量',
            barmode='stack',
            height=400
        )
        
        return fig
    except Exception as e:
        return go.Figure().add_annotation(text=f"图表生成错误: {str(e)}", x=0.5, y=0.5)

@cache_with_timeout(CACHE_TIMEOUT)
def create_company_fleet_chart():
    """优化的公司船队规模图表"""
    try:
        query = """
        SELECT sc.company_name, 
               sc.fleet_size,
               COALESCE(AVG(s.deadweight_tonnage), 0) as avg_tonnage
        FROM shipping_companies sc
        LEFT JOIN ships s ON sc.company_id = s.company_id
        WHERE sc.fleet_size > 0
        GROUP BY sc.company_id, sc.company_name, sc.fleet_size
        ORDER BY sc.fleet_size DESC
        LIMIT 10
        """
        df = db_manager.get_dataframe(query)
        
        if df.empty:
            return go.Figure().add_annotation(text="暂无公司数据", x=0.5, y=0.5)
        
        fig = make_subplots(specs=[[{"secondary_y": True}]])
        
        fig.add_trace(
            go.Bar(x=df['company_name'], y=df['fleet_size'], name="船队规模", marker_color='lightgreen'),
            secondary_y=False,
        )
        
        fig.add_trace(
            go.Scatter(x=df['company_name'], y=df['avg_tonnage'], 
                      name="平均载重", mode='lines+markers', line=dict(color='orange', width=3)),
            secondary_y=True,
        )
        
        fig.update_xaxes(title_text="公司")
        fig.update_yaxes(title_text="船只数量", secondary_y=False)
        fig.update_yaxes(title_text="平均载重吨位", secondary_y=True)
        fig.update_layout(title_text="船运公司船队规模与平均载重", height=400)
        
        return fig
    except Exception as e:
        return go.Figure().add_annotation(text=f"图表生成错误: {str(e)}", x=0.5, y=0.5)

def get_business_statistics():
    """获取业务统计概览 - 使用缓存"""
    stats = get_all_statistics()
    return {
        'total_orders': stats.get('total_orders', 0),
        'active_voyages': stats.get('active_voyages', 0),
        'total_ships': stats.get('total_ships', 0),
        'total_ports': stats.get('total_ports', 0),
        'monthly_revenue': stats.get('monthly_revenue', 0),
        'completed_orders': stats.get('completed_orders', 0),
        'in_transit_orders': stats.get('in_transit_orders', 0)
    }

def clear_cache():
    """清除缓存"""
    with cache_lock:
        chart_cache.clear()
        stats_cache.clear()
    return "缓存已清除，下次查询将获取最新数据"

# 跟踪和其他功能
def get_tracking_info(order_id: str):
    """获取订单跟踪信息"""
    if not order_id or order_id.strip() == "":
        return pd.DataFrame({"消息": ["请输入订单ID"]})
    
    try:
        order_id_int = int(order_id.strip())
        query = """
        SELECT tt.tracking_id as '跟踪ID', 
               CASE tt.tracking_status
                   WHEN 'order_received' THEN '已接收订单'
                   WHEN 'cargo_loaded' THEN '货物已装载'
                   WHEN 'departed' THEN '已出发'
                   WHEN 'in_transit' THEN '运输中'
                   WHEN 'arrived_destination' THEN '已到达目的地'
                   WHEN 'cargo_unloaded' THEN '货物已卸载'
                   WHEN 'delivered' THEN '已交付'
                   ELSE tt.tracking_status
               END as '状态',
               DATE_FORMAT(tt.tracking_time, '%Y-%m-%d %H:%i:%s') as '时间',
               COALESCE(p.port_name, '未知位置') as '位置港口', 
               COALESCE(tt.remarks, '无备注') as '备注'
        FROM transport_tracking tt
        LEFT JOIN ports p ON tt.location_port_id = p.port_id
        WHERE tt.order_id = %s
        ORDER BY tt.tracking_time DESC
        """
        df = db_manager.get_dataframe(query, (order_id_int,))
        
        if df.empty:
            return pd.DataFrame({"消息": [f"未找到订单ID {order_id_int} 的跟踪信息"]})
        
        return df
        
    except ValueError:
        return pd.DataFrame({"错误": ["订单ID必须是数字"]})
    except Exception as e:
        return pd.DataFrame({"错误": [f"查询失败: {str(e)}"]})

def get_order_details(order_id: str):
    """获取订单详细信息"""
    if not order_id or order_id.strip() == "":
        return pd.DataFrame({"消息": ["请输入订单ID"]})
    
    try:
        order_id_int = int(order_id.strip())
        query = """
        SELECT o.order_number as '订单编号',
               s.company_name as '发货人',
               c.company_name as '收货人',
               op.port_name as '起始港口',
               dp.port_name as '目的港口',
               CASE o.order_status
                   WHEN 'pending' THEN '待处理'
                   WHEN 'confirmed' THEN '已确认'
                   WHEN 'ship_assigned' THEN '已分配船只'
                   WHEN 'in_transit' THEN '运输中'
                   WHEN 'arrived' THEN '已到达'
                   WHEN 'completed' THEN '已完成'
                   WHEN 'cancelled' THEN '已取消'
                   ELSE o.order_status
               END as '订单状态',
               o.total_weight as '总重量(吨)',
               o.total_volume as '总体积(立方米)',
               o.freight_amount as '运费($)',
               DATE_FORMAT(o.order_date, '%Y-%m-%d') as '订单日期',
               DATE_FORMAT(o.required_delivery_date, '%Y-%m-%d') as '要求交货日期'
        FROM transport_orders o
        JOIN customers s ON o.shipper_id = s.customer_id
        JOIN customers c ON o.consignee_id = c.customer_id
        JOIN ports op ON o.origin_port_id = op.port_id
        JOIN ports dp ON o.destination_port_id = dp.port_id
        WHERE o.order_id = %s
        """
        df = db_manager.get_dataframe(query, (order_id_int,))
        
        if df.empty:
            return pd.DataFrame({"消息": [f"未找到订单ID {order_id_int}"]})
        
        return df
        
    except ValueError:
        return pd.DataFrame({"错误": ["订单ID必须是数字"]})
    except Exception as e:
        return pd.DataFrame({"错误": [f"查询失败: {str(e)}"]})

def update_order_status(order_id: str, new_status: str, remarks: str = ""):
    """更新订单状态"""
    try:
        if not order_id or not new_status:
            return "请填写订单ID和新状态"
        
        order_id_int = int(order_id.strip())
        
        # 更新订单状态
        query = "UPDATE transport_orders SET order_status = %s WHERE order_id = %s"
        result = db_manager.execute_query(query, (new_status, order_id_int), fetch=False)
        
        if result is True:
            # 添加跟踪记录
            tracking_status_map = {
                'confirmed': 'order_received',
                'ship_assigned': 'cargo_loaded',
                'in_transit': 'in_transit',
                'arrived': 'arrived_destination',
                'completed': 'delivered'
            }
            
            tracking_status = tracking_status_map.get(new_status, 'order_received')
            tracking_query = """
            INSERT INTO transport_tracking (order_id, tracking_status, tracking_time, remarks)
            VALUES (%s, %s, NOW(), %s)
            """
            db_manager.execute_query(tracking_query, (order_id_int, tracking_status, remarks), fetch=False)
            
            # 清除缓存
            clear_cache()
            
            return f"订单状态已更新为: {new_status}"
        else:
            return f"更新失败: {result}"
            
    except ValueError:
        return "订单ID必须是数字"
    except Exception as e:
        return f"更新失败: {str(e)}"

def create_shipping_interface():
    """创建主要的Gradio界面"""
    
    # 定义所有界面更新函数
    def update_stats():
        """更新统计数据"""
        stats = get_business_statistics()
        return (
            stats.get('total_orders', 0),
            stats.get('active_voyages', 0),
            stats.get('total_ships', 0),
            stats.get('total_ports', 0),
            stats.get('monthly_revenue', 0),
            stats.get('completed_orders', 0)
        )
    
    def update_charts():
        """更新图表"""
        return (
            create_monthly_orders_chart(),
            create_port_business_chart(),
            create_ship_status_chart(),
            create_company_fleet_chart()
        )
    
    # 自定义CSS样式
    custom_css = """
    .gradio-container {
        font-family: 'Microsoft YaHei', Arial, sans-serif;
    }
    .tab-nav {
        background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
    }
    .metric-card {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        border-radius: 10px;
        padding: 20px;
        color: white;
        text-align: center;
    }
    """
    
    with gr.Blocks(title="船运管理系统", theme=gr.themes.Soft(), css=custom_css) as app:
        gr.Markdown("# 🚢 船运管理系统")
        gr.Markdown("全面的船运业务管理与数据分析平台")
        
        # 业务概览标签页
        with gr.Tab("📊 业务概览"):
            gr.Markdown("## 关键业务指标")
            
            with gr.Row():
                with gr.Column():
                    total_orders_display = gr.Number(label="总订单数", interactive=False)
                    active_voyages_display = gr.Number(label="活跃航次", interactive=False)
                with gr.Column():
                    total_ships_display = gr.Number(label="船只总数", interactive=False)
                    total_ports_display = gr.Number(label="港口总数", interactive=False)
                with gr.Column():
                    monthly_revenue_display = gr.Number(label="本月收入 ($)", interactive=False)
                    completed_orders_display = gr.Number(label="已完成订单", interactive=False)
            
            with gr.Row():
                refresh_stats_btn = gr.Button("🔄 快速刷新", variant="primary")
                clear_cache_btn = gr.Button("🗑️ 清除缓存", variant="secondary")
                cache_status = gr.Textbox(label="缓存状态", interactive=False, value="使用缓存加速查询")
            
            gr.Markdown("## 业务图表分析")
            with gr.Row():
                with gr.Column():
                    monthly_chart = gr.Plot(label="月度订单与收入趋势")
                    port_chart = gr.Plot(label="港口业务量排名")
                with gr.Column():
                    ship_status_chart = gr.Plot(label="船只状态分布")
                    company_chart = gr.Plot(label="公司船队规模")
            
            refresh_charts_btn = gr.Button("📈 刷新图表", variant="secondary")
            
            refresh_stats_btn.click(
                update_stats,
                outputs=[total_orders_display, active_voyages_display, 
                        total_ships_display, total_ports_display,
                        monthly_revenue_display, completed_orders_display]
            )
            
            refresh_charts_btn.click(
                update_charts,
                outputs=[monthly_chart, port_chart, ship_status_chart, company_chart]
            )
            
            clear_cache_btn.click(
                clear_cache,
                outputs=cache_status
            )
        
        # 数据查看标签页
        with gr.Tab("🏢 公司管理"):
            gr.Markdown("## 船运公司")
            
            with gr.Row():
                with gr.Column(scale=2):
                    companies_table = gr.Dataframe(label="公司列表", interactive=False)
                    companies_refresh = gr.Button("🔄 刷新公司列表")
                
                with gr.Column(scale=1):
                    gr.Markdown("### 添加新公司")
                    company_name_input = gr.Textbox(label="公司名称")
                    company_country_input = gr.Textbox(label="注册国家")
                    company_phone_input = gr.Textbox(label="联系电话")
                    company_email_input = gr.Textbox(label="邮箱地址")
                    company_address_input = gr.Textbox(label="地址")
                    company_year_input = gr.Number(label="成立年份", precision=0)
                    add_company_btn = gr.Button("➕ 添加公司", variant="primary")
                    add_company_result = gr.Textbox(label="操作结果", interactive=False)
            
            companies_refresh.click(get_companies, outputs=companies_table)
            add_company_btn.click(
                add_shipping_company,
                inputs=[company_name_input, company_country_input, company_phone_input,
                       company_email_input, company_address_input, company_year_input],
                outputs=add_company_result
            )
        
        with gr.Tab("🚢 船只管理"):
            gr.Markdown("## 船只管理")
            
            with gr.Row():
                with gr.Column(scale=2):
                    ships_table = gr.Dataframe(label="船只列表", interactive=False)
                    ships_refresh = gr.Button("🔄 刷新船只列表")
                
                with gr.Column(scale=1):
                    gr.Markdown("### 添加新船只")
                    ship_name_input = gr.Textbox(label="船只名称")
                    ship_type_input = gr.Dropdown(
                        choices=[
                            ("货船", "cargo_ship"),
                            ("客船", "passenger_ship"),
                            ("集装箱船", "container_ship"),
                            ("油轮", "tanker"),
                            ("散货船", "bulk_carrier")
                        ],
                        label="船只类型"
                    )
                    ship_tonnage_input = gr.Number(label="载重吨位", precision=2)
                    ship_length_input = gr.Number(label="长度(米)", precision=2)
                    ship_width_input = gr.Number(label="宽度(米)", precision=2)
                    ship_year_input = gr.Number(label="建造年份", precision=0)
                    ship_company_input = gr.Number(label="所属公司ID", precision=0)
                    add_ship_btn = gr.Button("➕ 添加船只", variant="primary")
                    add_ship_result = gr.Textbox(label="操作结果", interactive=False)
            
            ships_refresh.click(get_ships, outputs=ships_table)
            add_ship_btn.click(
                add_ship,
                inputs=[ship_name_input, ship_type_input, ship_tonnage_input,
                       ship_length_input, ship_width_input, ship_year_input, ship_company_input],
                outputs=add_ship_result
            )
        
        with gr.Tab("🏰 港口管理"):
            gr.Markdown("## 港口管理")
            
            with gr.Row():
                with gr.Column(scale=2):
                    ports_table = gr.Dataframe(label="港口列表", interactive=False)
                    ports_refresh = gr.Button("🔄 刷新港口列表")
                
                with gr.Column(scale=1):
                    gr.Markdown("### 添加新港口")
                    port_name_input = gr.Textbox(label="港口名称")
                    port_city_input = gr.Textbox(label="城市")
                    port_country_input = gr.Textbox(label="国家")
                    port_type_input = gr.Dropdown(
                        choices=[
                            ("货运港", "cargo_port"),
                            ("客运港", "passenger_port"),
                            ("多用途港", "multi_purpose"),
                            ("专业港", "specialized_port")
                        ],
                        label="港口类型"
                    )
                    port_berth_input = gr.Number(label="泊位数量", precision=0)
                    port_draft_input = gr.Number(label="最大吃水", precision=2)
                    port_lat_input = gr.Number(label="纬度", precision=7)
                    port_lon_input = gr.Number(label="经度", precision=7)
                    add_port_btn = gr.Button("➕ 添加港口", variant="primary")
                    add_port_result = gr.Textbox(label="操作结果", interactive=False)
            
            ports_refresh.click(get_ports, outputs=ports_table)
            add_port_btn.click(
                add_port,
                inputs=[port_name_input, port_city_input, port_country_input, port_type_input,
                       port_berth_input, port_draft_input, port_lat_input, port_lon_input],
                outputs=add_port_result
            )
        
        with gr.Tab("👥 客户管理"):
            gr.Markdown("## 客户管理")
            
            with gr.Row():
                with gr.Column(scale=2):
                    customers_table = gr.Dataframe(label="客户列表", interactive=False)
                    customers_refresh = gr.Button("🔄 刷新客户列表")
                
                with gr.Column(scale=1):
                    gr.Markdown("### 添加新客户")
                    customer_name_input = gr.Textbox(label="公司名称")
                    customer_contact_input = gr.Textbox(label="联系人")
                    customer_phone_input = gr.Textbox(label="电话")
                    customer_email_input = gr.Textbox(label="邮箱")
                    customer_address_input = gr.Textbox(label="地址")
                    customer_type_input = gr.Dropdown(
                        choices=[
                            ("发货人", "shipper"),
                            ("收货人", "consignee"),
                            ("货代", "freight_forwarder"),
                            ("综合", "comprehensive")
                        ],
                        label="客户类型"
                    )
                    customer_rating_input = gr.Dropdown(
                        choices=["AAA", "AA", "A", "BBB", "BB", "B", "C"],
                        label="信用等级"
                    )
                    add_customer_btn = gr.Button("➕ 添加客户", variant="primary")
                    add_customer_result = gr.Textbox(label="操作结果", interactive=False)
            
            customers_refresh.click(get_customers, outputs=customers_table)
            add_customer_btn.click(
                add_customer,
                inputs=[customer_name_input, customer_contact_input, customer_phone_input,
                       customer_email_input, customer_address_input, customer_type_input,
                       customer_rating_input],
                outputs=add_customer_result
            )
        
        with gr.Tab("📦 订单管理"):
            gr.Markdown("## 运输订单管理")
            
            with gr.Row():
                with gr.Column(scale=2):
                    orders_table = gr.Dataframe(label="订单列表", interactive=False)
                    orders_refresh = gr.Button("🔄 刷新订单列表")
                
                with gr.Column(scale=1):
                    gr.Markdown("### 创建新订单")
                    order_shipper_input = gr.Number(label="发货人ID", precision=0)
                    order_consignee_input = gr.Number(label="收货人ID", precision=0)
                    order_origin_port_input = gr.Number(label="起始港口ID", precision=0)
                    order_dest_port_input = gr.Number(label="目的港口ID", precision=0)
                    order_weight_input = gr.Number(label="总重量(吨)", precision=2)
                    order_volume_input = gr.Number(label="总体积(立方米)", precision=2)
                    order_value_input = gr.Number(label="货物价值($)", precision=2)
                    order_delivery_date = gr.Textbox(
                        label="要求交货日期(YYYY-MM-DD)", 
                        value=str((date.today() + timedelta(days=30)).strftime("%Y-%m-%d"))
                    )
                    create_order_btn = gr.Button("➕ 创建订单", variant="primary")
                    create_order_result = gr.Textbox(label="创建结果", interactive=False)
            
            orders_refresh.click(get_orders, outputs=orders_table)
            create_order_btn.click(
                create_new_order,
                inputs=[order_shipper_input, order_consignee_input, order_origin_port_input,
                       order_dest_port_input, order_weight_input, order_volume_input,
                       order_value_input, order_delivery_date],
                outputs=create_order_result
            )
        
        with gr.Tab("🛳️ 航次管理"):
            gr.Markdown("## 航次管理")
            
            with gr.Row():
                with gr.Column(scale=2):
                    voyages_table = gr.Dataframe(label="航次列表", interactive=False)
                    voyages_refresh = gr.Button("🔄 刷新航次列表")
                
                with gr.Column(scale=1):
                    gr.Markdown("### 创建新航次")
                    voyage_ship_input = gr.Number(label="船只ID", precision=0)
                    voyage_origin_port_input = gr.Number(label="起始港口ID", precision=0)
                    voyage_dest_port_input = gr.Number(label="目的港口ID", precision=0)
                    voyage_departure_input = gr.Textbox(
                        label="出发时间(YYYY-MM-DD HH:MM)",
                        value=datetime.now().strftime("%Y-%m-%d %H:%M")
                    )
                    voyage_arrival_input = gr.Textbox(
                        label="预计到达时间(YYYY-MM-DD HH:MM)(可选)",
                        value=""
                    )
                    create_voyage_btn = gr.Button("➕ 创建航次", variant="primary")
                    create_voyage_result = gr.Textbox(label="创建结果", interactive=False)
                    
                    gr.Markdown("### 船只分配")
                    assign_order_input = gr.Number(label="订单ID", precision=0)
                    assign_ship_input = gr.Number(label="船只ID", precision=0)
                    assign_ship_btn = gr.Button("🔗 分配船只", variant="secondary")
                    assign_result = gr.Textbox(label="分配结果", interactive=False)
            
            voyages_refresh.click(get_voyages, outputs=voyages_table)
            create_voyage_btn.click(
                create_new_voyage,
                inputs=[voyage_ship_input, voyage_origin_port_input, voyage_dest_port_input,
                       voyage_departure_input, voyage_arrival_input],
                outputs=create_voyage_result
            )
            assign_ship_btn.click(
                assign_ship_to_order,
                inputs=[assign_order_input, assign_ship_input],
                outputs=assign_result
            )
        
        with gr.Tab("📍 订单跟踪"):
            gr.Markdown("## 订单状态跟踪与管理")
            
            with gr.Row():
                with gr.Column():
                    gr.Markdown("### 订单跟踪查询")
                    tracking_order_id = gr.Textbox(label="订单ID", placeholder="输入要查询的订单ID")
                    
                    with gr.Row():
                        track_btn = gr.Button("🔍 查询跟踪", variant="primary")
                        order_detail_btn = gr.Button("📋 查看订单详情", variant="secondary")
                    
                    tracking_table = gr.Dataframe(label="跟踪信息", interactive=False)
                    order_details_table = gr.Dataframe(label="订单详情", interactive=False)
                
                with gr.Column():
                    gr.Markdown("### 订单状态更新")
                    update_order_id = gr.Textbox(label="订单ID", placeholder="要更新的订单ID")
                    new_status = gr.Dropdown(
                        choices=[
                            ("待处理", "pending"),
                            ("已确认", "confirmed"),
                            ("已分配船只", "ship_assigned"),
                            ("运输中", "in_transit"),
                            ("已到达", "arrived"),
                            ("已完成", "completed"),
                            ("已取消", "cancelled")
                        ],
                        label="新状态"
                    )
                    status_remarks = gr.Textbox(
                        label="备注信息",
                        placeholder="可选：添加状态更新说明",
                        lines=3
                    )
                    update_status_btn = gr.Button("🔄 更新状态", variant="primary")
                    update_result = gr.Textbox(label="更新结果", interactive=False)
            
            # 绑定事件
            track_btn.click(
                get_tracking_info,
                inputs=tracking_order_id,
                outputs=tracking_table
            )
            
            order_detail_btn.click(
                get_order_details,
                inputs=tracking_order_id,
                outputs=order_details_table
            )
            
            update_status_btn.click(
                update_order_status,
                inputs=[update_order_id, new_status, status_remarks],
                outputs=update_result
            )
        
        with gr.Tab("ℹ️ 使用说明"):
            gr.Markdown("""
            ## 船运管理系统使用指南
            
            ### 主要功能：
            1. **业务概览**: 查看关键指标和业务图表分析
            2. **数据管理**: 管理公司、船只、港口、客户等基础数据
            3. **订单管理**: 创建和管理运输订单
            4. **航次管理**: 创建航次和分配船只
            5. **订单跟踪**: 跟踪运输订单的实时状态
            6. **数据分析**: 查看业务趋势和统计图表
            
            ### 新增订单流程：
            1. **查看客户ID**: 在"客户管理"标签页查看客户列表，记下发货人和收货人的ID
            2. **查看港口ID**: 在"港口管理"标签页查看港口列表，记下起始和目的港口的ID
            3. **创建订单**: 在"订单管理"标签页填写订单信息并创建
            4. **分配船只**: 订单创建后，在"航次管理"标签页为订单分配船只
            
            ### 新增航次流程：
            1. **查看船只ID**: 在"船只管理"标签页查看可用船只，记下船只ID
            2. **查看港口ID**: 在"港口管理"标签页查看港口列表，记下港口ID
            3. **创建航次**: 在"航次管理"标签页填写航次信息并创建
            
            ### ID查找指南：
            - **客户ID**: 客户管理 → 查看"客户ID"列
            - **港口ID**: 港口管理 → 查看"港口ID"列  
            - **船只ID**: 船只管理 → 查看"船只ID"列
            - **订单ID**: 订单管理 → 查看"订单ID"列
            
            ### 操作注意事项：
            - 创建记录后会自动清除缓存，确保数据同步
            - 填写表单时请确保所有必填字段都已填写
            - 图表会根据新数据自动更新
            - 通过订单ID可以跟踪货物状态
            - 只有状态为"在港"的船只才能分配给新订单
            
            ### 日期时间格式：
            - **日期格式**: YYYY-MM-DD (例如: 2024-03-15)
            - **时间格式**: YYYY-MM-DD HH:MM (例如: 2024-03-15 14:30)
            
            ### 性能优化：
            - 系统使用5分钟缓存机制提高响应速度
            - 如需查看最新数据，点击"清除缓存"按钮
            - 图表和统计数据可以独立刷新
            
            ### 故障排除：
            - 如果创建失败，请检查输入的ID是否存在
            - 确保数据库连接正常
            - 检查日期时间格式是否正确
            - 船只分配失败可能是因为船只状态不正确
            """)
        
        # 页面加载时初始化数据
        def initialize_data():
            """初始化页面数据"""
            try:
                # 获取基础数据
                companies = get_companies()
                ships = get_ships()
                ports = get_ports()
                customers = get_customers()
                orders = get_orders()
                voyages = get_voyages()
                
                # 获取统计数据
                stats = get_business_statistics()
                stats_values = (
                    stats.get('total_orders', 0),
                    stats.get('active_voyages', 0),
                    stats.get('total_ships', 0),
                    stats.get('total_ports', 0),
                    stats.get('monthly_revenue', 0),
                    stats.get('completed_orders', 0)
                )
                
                # 获取图表
                charts = (
                    create_monthly_orders_chart(),
                    create_port_business_chart(),
                    create_ship_status_chart(),
                    create_company_fleet_chart()
                )
                
                return (companies, ships, ports, customers, orders, voyages, *stats_values, *charts)
                
            except Exception as e:
                # 如果初始化失败，返回空数据
                empty_df = pd.DataFrame({"提示": ["数据加载中，请稍后刷新"]})
                empty_fig = go.Figure().add_annotation(text="加载中...", x=0.5, y=0.5)
                return (empty_df, empty_df, empty_df, empty_df, empty_df, empty_df,
                       0, 0, 0, 0, 0, 0, empty_fig, empty_fig, empty_fig, empty_fig)
        
        # 页面加载事件
        app.load(
            initialize_data,
            outputs=[
                companies_table, ships_table, ports_table, 
                customers_table, orders_table, voyages_table,
                total_orders_display, active_voyages_display, 
                total_ships_display, total_ports_display,
                monthly_revenue_display, completed_orders_display,
                monthly_chart, port_chart, ship_status_chart, company_chart
            ]
        )
    
    return app

# 主程序执行
if __name__ == "__main__":
    # 创建并启动应用
    app = create_shipping_interface()
    
    # 启动设置
    app.launch(
        server_name="127.0.0.1",
        server_port=7860,
        share=False,
        debug=True,
        show_error=True
    )