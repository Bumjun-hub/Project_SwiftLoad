import React from 'react';
import { Link, useLocation } from 'react-router-dom';
import './Sidebar.css';

function Sidebar({ open }) {
  const location = useLocation();
  const getActive = (path) =>
    location.pathname === path
      ? 'sidebar-link sidebar-link-active'
      : 'sidebar-link';

  return (
    <nav className={`sidebar ${open ? 'sidebar-open' : 'sidebar-closed'}`}>
      <div>
        <Link to="/" className={getActive('/')}>
          견적 관리
        </Link>
      </div>
      <div>
        <Link to="/drivers" className={getActive('/drivers')}>
          차주 관리
        </Link>
      </div>
      <div>
        <Link to="/drivers/pending" className={getActive('/drivers/pending')}>
          기사님 요청
        </Link>
      </div>
      <div>
        <Link to="/payments" className={getActive('/payments')}>
          결제 관리
        </Link>
      </div>
    </nav>
  );
}
export default Sidebar;
