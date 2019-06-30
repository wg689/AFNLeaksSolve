import React from 'react';
import {Row, Col,Carousel,Form} from 'antd';
import {
	Tabs,
} from 'antd';

const TabPane = Tabs.TabPane;


export default  class PCNewsContainer  extends React.Component {

	render() {
    const setting = {
      dots: true,
      infinite:true,
      speed:500,
      slidesToShow:1,
      autoplay:true
    }

    return (
      <div>
        <row>
          <Col span={2}></Col>
          <Col span={20} class="container">
            <div class="leftContainer">
              <div class="carousel">
                <Carousel {...setting}>
                  <div> <img src="./src/images/carousel_1.jpg" alt=""/> </div>
                  <div> <img src="./src/images/carousel_2.jpg" alt=""/> </div>
                  <div> <img src="./src/images/carousel_3.jpg" alt=""/> </div>
                  <div> <img src="./src/images/carousel_4.jpg" alt=""/> </div>
                </Carousel>
              </div>
            </div>
          </Col>
          <Col span={2}></Col>
        </row>

      </div>

		);
	};
}

// PCNewsContainer = Form.create({})(PCNewsContainer);
