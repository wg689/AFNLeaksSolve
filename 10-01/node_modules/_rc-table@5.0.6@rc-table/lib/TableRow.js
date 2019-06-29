'use strict';

Object.defineProperty(exports, "__esModule", {
  value: true
});

var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };

var _react = require('react');

var _react2 = _interopRequireDefault(_react);

var _shallowequal = require('shallowequal');

var _shallowequal2 = _interopRequireDefault(_shallowequal);

var _TableCell = require('./TableCell');

var _TableCell2 = _interopRequireDefault(_TableCell);

var _ExpandIcon = require('./ExpandIcon');

var _ExpandIcon2 = _interopRequireDefault(_ExpandIcon);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }

var TableRow = _react2["default"].createClass({
  displayName: 'TableRow',

  propTypes: {
    onDestroy: _react.PropTypes.func,
    onRowClick: _react.PropTypes.func,
    onRowDoubleClick: _react.PropTypes.func,
    record: _react.PropTypes.object,
    prefixCls: _react.PropTypes.string,
    expandIconColumnIndex: _react.PropTypes.number,
    onHover: _react.PropTypes.func,
    columns: _react.PropTypes.array,
    style: _react.PropTypes.object,
    visible: _react.PropTypes.bool,
    index: _react.PropTypes.number,
    hoverKey: _react.PropTypes.any,
    expanded: _react.PropTypes.bool,
    expandable: _react.PropTypes.any,
    onExpand: _react.PropTypes.func,
    needIndentSpaced: _react.PropTypes.bool,
    className: _react.PropTypes.string,
    indent: _react.PropTypes.number,
    indentSize: _react.PropTypes.number,
    expandIconAsCell: _react.PropTypes.bool,
    expandRowByClick: _react.PropTypes.bool
  },

  getDefaultProps: function getDefaultProps() {
    return {
      onRowClick: function onRowClick() {},
      onRowDoubleClick: function onRowDoubleClick() {},
      onDestroy: function onDestroy() {},

      expandIconColumnIndex: 0,
      expandRowByClick: false,
      onHover: function onHover() {}
    };
  },
  shouldComponentUpdate: function shouldComponentUpdate(nextProps) {
    return !(0, _shallowequal2["default"])(nextProps, this.props);
  },
  componentWillUnmount: function componentWillUnmount() {
    this.props.onDestroy(this.props.record);
  },
  onRowClick: function onRowClick(event) {
    var _props = this.props,
        record = _props.record,
        index = _props.index,
        onRowClick = _props.onRowClick,
        expandable = _props.expandable,
        expandRowByClick = _props.expandRowByClick,
        expanded = _props.expanded,
        onExpand = _props.onExpand;

    if (expandable && expandRowByClick) {
      onExpand(!expanded, record);
    }
    onRowClick(record, index, event);
  },
  onRowDoubleClick: function onRowDoubleClick(event) {
    var _props2 = this.props,
        record = _props2.record,
        index = _props2.index,
        onRowDoubleClick = _props2.onRowDoubleClick;

    onRowDoubleClick(record, index, event);
  },
  onMouseEnter: function onMouseEnter() {
    var _props3 = this.props,
        onHover = _props3.onHover,
        hoverKey = _props3.hoverKey;

    onHover(true, hoverKey);
  },
  onMouseLeave: function onMouseLeave() {
    var _props4 = this.props,
        onHover = _props4.onHover,
        hoverKey = _props4.hoverKey;

    onHover(false, hoverKey);
  },
  render: function render() {
    var _props5 = this.props,
        prefixCls = _props5.prefixCls,
        columns = _props5.columns,
        record = _props5.record,
        style = _props5.style,
        visible = _props5.visible,
        index = _props5.index,
        expandIconColumnIndex = _props5.expandIconColumnIndex,
        expandIconAsCell = _props5.expandIconAsCell,
        expanded = _props5.expanded,
        expandRowByClick = _props5.expandRowByClick,
        expandable = _props5.expandable,
        onExpand = _props5.onExpand,
        needIndentSpaced = _props5.needIndentSpaced,
        className = _props5.className,
        indent = _props5.indent,
        indentSize = _props5.indentSize;


    var cells = [];

    var expandIcon = _react2["default"].createElement(_ExpandIcon2["default"], {
      expandable: expandable,
      prefixCls: prefixCls,
      onExpand: onExpand,
      needIndentSpaced: needIndentSpaced,
      expanded: expanded,
      record: record
    });

    for (var i = 0; i < columns.length; i++) {
      if (expandIconAsCell && i === 0) {
        cells.push(_react2["default"].createElement(
          'td',
          {
            className: prefixCls + '-expand-icon-cell',
            key: 'rc-table-expand-icon-cell'
          },
          expandIcon
        ));
      }
      var isColumnHaveExpandIcon = expandIconAsCell || expandRowByClick ? false : i === expandIconColumnIndex;
      cells.push(_react2["default"].createElement(_TableCell2["default"], {
        prefixCls: prefixCls,
        record: record,
        indentSize: indentSize,
        indent: indent,
        index: index,
        column: columns[i],
        key: columns[i].key,
        expandIcon: isColumnHaveExpandIcon ? expandIcon : null
      }));
    }

    return _react2["default"].createElement(
      'tr',
      {
        onClick: this.onRowClick,
        onDoubleClick: this.onRowDoubleClick,
        onMouseEnter: this.onMouseEnter,
        onMouseLeave: this.onMouseLeave,
        className: prefixCls + ' ' + className + ' ' + prefixCls + '-level-' + indent,
        style: visible ? style : _extends({}, style, { display: 'none' })
      },
      cells
    );
  }
});

exports["default"] = TableRow;
module.exports = exports['default'];