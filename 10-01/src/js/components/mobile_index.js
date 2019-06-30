import React from 'react';
import MobileHeader from './mobile_header';
import MobileFooter from './mobile_footer'
import {Tabs} from 'antd'
const TabPane = Tabs.TabPane;
import MobileList from './mobile_list'


export default class MobileIndex extends React.Component {
	render() {
		return (
			<div>
				<MobileHeader></MobileHeader>
				<Tabs>
					<TabPane tab="头条" key= "1">
						<MobileList count={20} type="top"></MobileList>
					</TabPane>
					<TabPane tab="社会" key= "2">
						<MobileList count={20} type="guonei"></MobileList>
					</TabPane>
					<TabPane tab="国内" key= "3">
						<MobileList count={20} type="top"></MobileList>
					</TabPane>
					<TabPane tab="国际" key= "4">
						<MobileList count={20} type="top"></MobileList>
					</TabPane>
					<TabPane tab="娱乐" key= "5">
						<MobileList count={20} type="top"></MobileList>
					</TabPane>
				</Tabs>
				<MobileFooter></MobileFooter>
			</div>
		);
	};
}
