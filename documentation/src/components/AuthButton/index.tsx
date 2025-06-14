import Link from "@docusaurus/Link";
import { auth, logout } from "@site/src/theme/Root/firebase";
import type { User } from "firebase/auth";

import Translate from "@docusaurus/Translate";

export default function AuthButton() {
  const user = auth.currentUser as User;

  if (user) return <LogoutButton />;

  return <LoginButton />;
}

function LoginButton() {
  return (
    <Link className="button button--primary" to="/login">
      <Translate>Войти</Translate>
    </Link>
  );
}

function LogoutButton() {
  const user = auth.currentUser as User;

  return (
    <div className="dropdown dropdown--hoverable">
      <div data-toggle="dropdown">
        <div className="avatar margin-right--md">
          <img
            className="avatar__photo avatar__photo--sm"
            src={user.photoURL}
          />
          <div className="avatar__intro">
            <div className="avatar__name">{user.displayName}</div>
          </div>
        </div>
      </div>
      <ul className="dropdown__menu">
        <li>
          <a
            className="dropdown__link dropdown__link--active"
            style={{ cursor: "pointer" }}
            onClick={() => logout(() => window.location.reload())}
          >
            <Translate>Выйти</Translate>
          </a>
        </li>
      </ul>
    </div>
  );
}
