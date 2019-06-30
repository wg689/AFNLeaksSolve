import React from 'react';
import {Row, Col} from 'antd';

export default class MobileFooter extends React.Component {
	constructor() {
		super();
		this.state = {
			current: 'top'
		};
	}
	render() {
		return (
			<header>
				<Row>
					<Col span={2}></Col>
					<Col span={20} class="footer">
            &copy;&nbsp;2019react news. all rights Reserved.
					</Col>
					<Col span={2}></Col>
				</Row>
			</header>
		);
	};
}
