import Link from "@docusaurus/Link";
import { auth, logout } from "@site/src/theme/Root/firebase";

import Translate from "@docusaurus/Translate";

export default function AuthButton() {
  const user = auth.currentUser;

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
  return (
    <a
      className="button button--secondary"
      onClick={() => logout(() => window.location.reload())}
    >
      <Translate>Выйти</Translate>
    </a>
  );
}
