import { AppProvider, useApp } from './store';
import { PhoneShell } from './components/PhoneShell';
import { LoginScreen } from './screens/LoginScreen';
import { CatalogScreen } from './screens/CatalogScreen';
import { DetailScreen } from './screens/DetailScreen';
import { VoucherScreen } from './screens/VoucherScreen';
import { PassportScreen } from './screens/PassportScreen';
import { ProfileScreen } from './screens/ProfileScreen';
import { BarqueiroScreen } from './screens/BarqueiroScreen';
import { BoatTripFormScreen } from './screens/BoatTripFormScreen';
import { GuiaScreen } from './screens/GuiaScreen';
import { TrailFormScreen } from './screens/TrailFormScreen';
import { ArtesaScreen } from './screens/ArtesaScreen';
import { CraftFormScreen } from './screens/CraftFormScreen';
import { CozinheiraScreen } from './screens/CozinheiraScreen';
import { MealFormScreen } from './screens/MealFormScreen';

function Router() {
  const { screen } = useApp();

  switch (screen) {
    case 'login':
      return <LoginScreen />;
    case 'catalog':
      return <CatalogScreen />;
    case 'detail':
      return <DetailScreen />;
    case 'voucher':
      return <VoucherScreen />;
    case 'passport':
      return <PassportScreen />;
    case 'profile':
      return <ProfileScreen />;
    case 'barqueiro':
      return <BarqueiroScreen />;
    case 'boatTripForm':
      return <BoatTripFormScreen />;
    case 'guia':
      return <GuiaScreen />;
    case 'trailForm':
      return <TrailFormScreen />;
    case 'artesa':
      return <ArtesaScreen />;
    case 'craftForm':
      return <CraftFormScreen />;
    case 'cozinheira':
      return <CozinheiraScreen />;
    case 'mealForm':
      return <MealFormScreen />;
    default:
      return <LoginScreen />;
  }
}

function App() {
  return (
    <AppProvider>
      <PhoneShell>
        <Router />
      </PhoneShell>
    </AppProvider>
  );
}

export default App;
