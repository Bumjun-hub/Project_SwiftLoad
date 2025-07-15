import { signInWithPopup } from "firebase/auth";
import { auth, googleProvider } from "../firebase";
import './LoginPage.css';
import { useNavigate } from "react-router-dom";

function LoginPage({ onLogin }) {
    const navigate = useNavigate();
  const handleLogin = async () => {
    try {
      const result = await signInWithPopup(auth, googleProvider);
      if (onLogin) onLogin(result.user);
      navigate('/');
    } catch (e) {
      alert("구글로그인 실패: " + e.message);
    }
  };

  return (
    <div className="login-bg">
      <div className="login-box">
        <h2 className="login-title">관리자 로그인</h2>
        <button className="login-google-btn" onClick={handleLogin}>
          <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/google/google-original.svg"
               alt="google" width={24} style={{ verticalAlign: "middle", marginRight: "10px" }} />
          Google로 로그인
        </button>
      </div>
    </div>
  );
}
export default LoginPage;
