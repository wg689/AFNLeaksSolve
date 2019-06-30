import React from 'react';
import {
  Row,
  Col
} from 'antd';
import {
  Menu,
  Icon,
	Tabs,
  Message,
  Form,
  Input,
  Button,
  CheckBox,
	Modal
} from 'antd';
const SubMenu = Menu.SubMenu;
const FormItem = Form.Item;
const MenuItemGroup = Menu.ItemGroup;
const TabPane = Tabs.TabPane;
class PCHeader extends React.Component {
	constructor() {
		super();
		this.state = {
			current: 'top',
			modalVisible:false,
			action:'login',
			hasLogined:false,
			userNickName:'',
			userid:0
		};
	};

	setModalVisible(value) {
		console.log('控制台电机');

	  this.setState ({
	    modeVisible: value
	  });
	};

	handleClick(e){
		console.log("handleClick");
		if(e.key == "register"){
			console.log("register");
			this.setState({current:'register'});
			this.setModalVisible(true);
		}else{
			this.setState({current:e.key});
		}
	};


	handleSubmit(){
		// 页面开始提交之后 开始提交数据
	}


	render() {

		let {getFieldProps} = this.props.form;
		const userShow = this.state.hasLogined
		?
		<Menu.Item key="logout" class = "register">
			<Button type ="dashed" htmlType="button">{this.state.userNickName}</Button>
			&nbsp;&nbsp;
			<Link target="_blank">个人中心</Link>
			&nbsp;&nbsp;
			<Button type ="ghost" htmlType="button">退出</Button>
		</Menu.Item>
		:
		<Menu.Item key="register" class = "register">
			<Icon type="appstore"/>注册/登录
		</Menu.Item>;

		return (
			<header>
				<Row>
					<Col span={2}></Col>
					<Col span={4}>
						<a href="/" class="logo">
							<img src="./src/images/logo.png" alt="logo"/>
							<span>ReactNews</span>
						</a>
					</Col>
					<Col span={16}>
						<Menu mode="horizontal" onClick={this.handleClick.bind(this)} selectedKeys={[this.state.current]}>
							<Menu.Item key="top">
								<Icon type="appstore"/>头条
							</Menu.Item>
							<Menu.Item key="shehui">
								<Icon type="appstore"/>社会
							</Menu.Item>
							<Menu.Item key="guonei">
								<Icon type="appstore"/>国内
							</Menu.Item>
							<Menu.Item key="guoji">
								<Icon type="appstore"/>国际
							</Menu.Item>
							<Menu.Item key="yule">
								<Icon type="appstore"/>娱乐
							</Menu.Item>
							<Menu.Item key="tiyu">
								<Icon type="appstore"/>体育
							</Menu.Item>
							<Menu.Item key="keji">
								<Icon type="appstore"/>科技
							</Menu.Item>
							<Menu.Item key="shishang">
								<Icon type="appstore"/>时尚
							</Menu.Item>
							{userShow}
						</Menu>
            <Modal title= "用户中心" wrapClassName="vertical-center-modal" visible= {this.state.modalVisible} onCancel={()=>this.setModalVisible(false)} onOk={()=>this.setModalVisible(false)} okText="关闭" >
	           	<Tabs type ="card">
							  <TabPane tab="注册" key="2">
									<Form horizontal onSubMit={this.handleSubmit.bind(this)}>
										<FormItem lable="账户">
											<Input placeHolder="请输入您的账户" {...getFieldProps('r_userName')}/>
										</FormItem>
										<FormItem lable="密码">
											<Input type="password" placeHolder="请输入您的密码" {...getFieldProps('r_password')}/>
										</FormItem>
										<FormItem lable="确认密码">
											<Input type="password" placeHolder="请再次输入您的密码" {...getFieldProps('r_confirmPassword')}/>
										</FormItem>
										<Button type="primary"></Button>
									</Form>
								</TabPane>
							</Tabs>
						</Modal>


					</Col>
					<Col span={2}></Col>
				</Row>
			</header>
		);
	};
}

export  default PCHeader = Form.create({})(PCHeader);
