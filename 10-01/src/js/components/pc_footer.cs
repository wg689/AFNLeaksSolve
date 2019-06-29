import React from 'react';
import {Row, Col} from 'antd';

export default class PCFooter extends React.Component {
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
					<Col span={20}>

					</Col>
					<Col span={2}></Col>
				</Row>
			</header>
		);
	};
}
