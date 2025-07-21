// src/components/DetailModal.js
import React from 'react';
import './DetailModal.css';

function DetailModal({ open, onClose, estimate }) {
  if (!open || !estimate) return null;

  // 날짜 변환 헬퍼
  const formatDate = (ts) =>
    ts?.toDate ? ts.toDate().toLocaleString() : (ts || '-');

  return (
    <div className="modal-overlay">
      <div className="modal-box">
        <button className="modal-close-btn" onClick={onClose}>×</button>
        <h2>견적 상세정보</h2>
        <div className="modal-section">
          <h4>화주 정보</h4>
          <div>이름: <b>{estimate.departureName || '-'}</b></div>
          <div>연락처: <b>{estimate.departureContact || '-'}</b></div>
        </div>
        <div className="modal-section">
          <h4>운송 정보</h4>
          <div>출발지: <b>{estimate.departureAddress || '-'}</b></div>
          <div>도착지: <b>{estimate.arrivalAddress || '-'}</b></div>
          <div>상차 예정일시: <b>
            {estimate.pickupDateTimeOption ? estimate.pickupDateTimeOption + ' ' : ''}
            {formatDate(estimate.pickupDateTime)}
          </b></div>
          <div>차종: <b>{estimate.selectedCarType || '-'}</b></div>
          <div>톤수: <b>{estimate.selectedTon || '-'}</b></div>
          <div>견적금액: <b>{estimate.calculatedPrice ? estimate.calculatedPrice.toLocaleString() + '원' : '-'}</b></div>
        </div>
        <div className="modal-section">
          <h4>상세 내용</h4>
          <div>물품 내용: <b>{estimate.content || '-'}</b></div>
        </div>
        {/* 필요시 추가 정보 */}
        <div className="modal-section">
          <h4>도착지 담당자</h4>
          <div>이름: <b>{estimate.arrivalName || '-'}</b></div>
          <div>연락처: <b>{estimate.arrivalContact || '-'}</b></div>
        </div>
      </div>
    </div>
  );
}

export default DetailModal;
