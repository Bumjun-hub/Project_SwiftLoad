import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import EstimateListPage from './pages/EstimateListPage';
import DriverListPage from './pages/DriverListPage';
import PendingDriverListPage from './pages/PendingDriverListPage';
import Header from './components/Header';
import Sidebar from './components/Sidebar';
import { useEffect, useState } from 'react';
import LoginPage from './pages/LoginPage';
import { onAuthStateChanged } from "firebase/auth";
import { auth } from "./firebase";
import PaymentListPage from './pages/PaymentListPage';

const ADMIN_EMAILS = [
  "jc971017@gmail.com"
];

function App() {
  const [sidebarOpen, setSidebarOpen] = useState(true);
  const handleSidebarToggle = () => setSidebarOpen(v => !v);
  const [user, setUser] = useState(null);

  useEffect(() => {
    const unsubscribe = onAuthStateChanged(auth, setUser);
    return unsubscribe;
  }, []);

  return (
    <Router>
      {/* 로그인 안 했을 때 로그인페이지만 */}
      {!user ? (
        <LoginPage onLogin={setUser} />
      ) :
        /* 로그인 했는데 관리자 이메일 아님 */
        !ADMIN_EMAILS.includes(user.email) ? (
          <div style={{
            minHeight: "100vh",
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            fontWeight: 700,
            color: "#e84118",
            fontSize: "1.2rem"
          }}>
            ❌ 관리자 권한이 없습니다.<br />
            (관리자 이메일로 로그인하세요.)
          </div>
        ) : (
          /* 관리자만 아래 관리자페이지 접근 */
          <>
            <Header onSidebarToggle={handleSidebarToggle} user={user} />
            <div style={{ display: 'flex' }}>
              <Sidebar open={sidebarOpen} />
              <div style={{ flex: 1 }}>
                <Routes>
                  <Route path="/" element={<EstimateListPage />} />
                  <Route path="/drivers" element={<DriverListPage />} />
                  <Route path="/drivers/pending" element={<PendingDriverListPage />} />
                  <Route path="/login" element={<LoginPage onLogin={setUser} />} />
                  <Route path="/payments/" element={<PaymentListPage />} />
                </Routes>
              </div>
            </div>
          </>
        )}
    </Router>
  );
}

export default App;
