import React from 'react';
import {Row, Col} from 'antd';
import {Tabs,Carousel} from 'antd';
const TabPane = Tabs.TabPane;
import PCNewsBlock from './pc_new_block';
import PCNewsImageBlock from './pc_news_image_block';
export default class PCNewsContainer extends React.Component {
	render() {

    const settings = {
        dots:true,
        infinite:true,
        speed: 500,
        slidesToShow:1,
        autoplay:true
    };


		return (
			<div>
				<Row>
					<Col span={2}></Col>
					<Col span={20} class="container">
            <div class="leftContainer">
              <div class="carousel">
                <Carousel {...settings}>
                  <div><img src="./src/images/carousel_1.jpg"/></div>
                  <div><img src="./src/images/carousel_2.jpg"/></div>
                  <div><img src="./src/images/carousel_3.jpg"/></div>
                  <div><img src="./src/images/carousel_4.jpg"/></div>
                </Carousel>
              </div>
							<PCNewsImageBlock count = {6} type="guoji" width="800px" cardTitle="国际头条" imageWidth = "112px"></PCNewsImageBlock>

					  </div>
            <Tabs class="tabs_news">
              <TabPane tab="头条" key="1">
                <PCNewsBlock count ={10} type = "yule" width ="100%" bordered="false">
                </PCNewsBlock>
              </TabPane>
              <TabPane tab="国际新闻" key="2">
                <PCNewsBlock count ={10} type = "guoji" width ="100%" bordered="false">
                </PCNewsBlock>
              </TabPane>
            </Tabs>
						<div>
							<PCNewsImageBlock count = {6} type="guonei" width="100%" cardTitle="国际头条" imageWidth = "132px"></PCNewsImageBlock>
							<PCNewsImageBlock count = {6} type="yule" width="100%" cardTitle="国际头条" imageWidth = "132px"></PCNewsImageBlock>

						</div>
          </Col>
					<Col span={2}></Col>
				</Row>
			</div>
		);
	};
}
