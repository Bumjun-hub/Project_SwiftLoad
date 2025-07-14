// src/components/DetailModal.js
import React from 'react';
import './DetailModal.css';

function DetailModal({ open, onClose, estimate }) {
  if (!open || !estimate) return null;

  return (
    <div className="modal-overlay">
      <div className="modal-box">
        <button className="modal-close-btn" onClick={onClose}>×</button>
        <h2>견적 상세정보</h2>
        <div className="modal-section">
          <h4>화주 정보</h4>
          <div>이름: <b>{estimate.shipper}</b></div>
          {/* 실제 데이터 구조에 따라 더 추가 */}
        </div>
        <div className="modal-section">
          <h4>차량/운송</h4>
          <div>차량: <b>{estimate.car}</b></div>
          <div>상차 시간: <b>{estimate.loadTime}</b></div>
          <div>매칭 상태: <b>{estimate.status}</b></div>
          <div>매칭 기사: <b>{estimate.matchedDriver}</b></div>
        </div>
        {/* 필요하면 더 많은 정보 추가! */}
      </div>
    </div>
  );
}

export default DetailModal;
