// src/components/DriverDetailModal.js
import React from 'react';
import './DetailModal.css'; // 기존 모달 스타일 그대로 사용

function DriverDetailModal({ open, onClose, driver }) {
    if (!open || !driver) return null;

    return (
        <div className="modal-overlay">
            <div className="modal-box">
                <button className="modal-close-btn" onClick={onClose}>×</button>
                <h2>차주 상세정보</h2>
                <div className="modal-section">
                    <h4>기본 정보</h4>
                    <div>이름: <b>{driver.name}</b></div>
                    <div>전화번호: <b>{driver.phone}</b></div>
                </div>
                <div className="modal-section">
                    <h4>차량 정보</h4>
                    <div>차량: <b>{driver.carType}</b></div>
                </div>
                <div className="modal-section">
                    <h4>상태</h4>
                    <div>승인일시: <b>{driver.approvedAt}</b></div>
                    <div>상태: <b>{driver.status === 'APPROVED' ? '승인됨' : driver.status}</b></div>
                </div>
                {/* 필요시, 서류/이미지/면허번호 등 필드 확장 가능 */}
            </div>
        </div>
    );
}

export default DriverDetailModal;
