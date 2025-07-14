// src/components/Header.js
import React from 'react';
import './Header.css';

function Header({ onSidebarToggle }) {
  return (
    <header className="header">
      <button className="sidebar-toggle-btn" onClick={onSidebarToggle}>
        <span className="hamburger-icon">&#9776;</span>
      </button>
      <div className="header-logo">
        {/* 로고는 직접 SVG로 넣거나 img 태그로 */}
        {/* 예시: 피그마 SVG export 코드 or img src */}
        <img src="/logo_swiftload.png" alt="SwiftLoad 로고" height={40} />
      </div>
    </header>
  );
}

export default Header;
