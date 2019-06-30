import React from 'react';
import {
  Row,
  Col
} from 'antd';
import {
  Menu,
  Icon,
	Tabs,
  message,
  Form,
  Input,
  Button,
  CheckBox,
	modal
} from 'antd';
const SubMenu = Menu.SubMenu;
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






	// setModalVisible(value){
	// 	this.setState{(modeVisible:value)}
	// };

	handleClick(e){
		if(e.key == "register"){
			this.setState({current:'register'});
		}else{
			this.setState({current:e.key});
		}
	};


	handleSubmit(){

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
						<Menu mode="horizontal" onclik={this.handleClick.bind(this)} selectedKeys={[this.state.current]}>
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
					</Col>
					<Col span={2}></Col>
				</Row>
			</header>
		);
	};
}

export  default PCHeader = Form.create({})(PCHeader);
