import React from 'react';
import { useNavigate } from 'react-router-dom';
import { signOut } from 'firebase/auth';
import { auth } from '../firebase'; // 반드시 firebase.js에서 export한 auth import!

import './Header.css';

function Header({ onSidebarToggle, user }) {
  const navigate = useNavigate();

  // 로그아웃 버튼 클릭시 실행
  const handleLogout = async () => {
    await signOut(auth); // 파이어베이스 로그아웃
    navigate('/login');  // 로그아웃 후 로그인페이지로 이동(원하면 다른 페이지로 이동 가능)
  };

  return (
    <header className="header">
      <button className="sidebar-toggle-btn" onClick={onSidebarToggle}>
        <span className="hamburger-icon">&#9776;</span>
      </button>
      <div className="header-logo">
        <img src="/logo_swiftload.png" alt="SwiftLoad 로고" height={40} />
      </div>
      <div style={{ position: 'absolute', right: 24, top: 14 }}>
        {/* 로그인 안 했을 때는 로그인 버튼 */}
        {!user && (
          <button
            className="header-login-btn"
            onClick={() => navigate('/login')}
          >
            로그인
          </button>
        )}
        {/* 로그인 했을 때는 이름+로그아웃 버튼 */}
        {user && (
          <>
            <span style={{ fontWeight: 600, marginRight: 10 }}>
              {user.displayName || user.email}
            </span>
            <button
              className="header-login-btn"
              style={{ background: '#fff', color: '#222', border: '1px solid #FFD600', marginLeft: 5 }}
              onClick={handleLogout}
            >
              로그아웃
            </button>
          </>
        )}
      </div>
    </header>
  );
}
export default Header;
