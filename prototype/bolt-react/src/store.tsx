import { createContext, useContext, useState, useEffect, type ReactNode } from 'react';
import type { AppData, Role, Theme, Screen, Voucher, BoatTrip, Trail, CraftItem, Meal } from './types';
import { defaultData } from './data';

interface AppContextValue {
  data: AppData;
  screen: Screen;
  setScreen: (s: Screen) => void;
  setRole: (r: Role) => void;
  toggleTheme: () => void;
  login: () => void;
  logout: () => void;
  selectExperience: (id: string) => void;
  addVoucher: (v: Voucher) => void;
  addBoatTrip: (t: BoatTrip) => void;
  addTrail: (t: Trail) => void;
  addCraft: (c: CraftItem) => void;
  addMeal: (m: Meal) => void;
  updateMealReserved: (id: string, reserved: number) => void;
}

const AppContext = createContext<AppContextValue | null>(null);
const STORAGE_KEY = 'banzeiro-tour-data-v1';

function loadData(): AppData {
  try {
    const raw = localStorage.getItem(STORAGE_KEY);
    if (raw) {
      const parsed = JSON.parse(raw);
      return { ...defaultData, ...parsed };
    }
  } catch {
    // ignore
  }
  return defaultData;
}

export function AppProvider({ children }: { children: ReactNode }) {
  const [data, setData] = useState<AppData>(loadData);
  const [screen, setScreen] = useState<Screen>('login');

  useEffect(() => {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(data));
  }, [data]);

  useEffect(() => {
    document.documentElement.classList.toggle('dark', data.theme === 'dark');
  }, [data.theme]);

  const setRole = (r: Role) => {
    setData((d) => ({ ...d, currentRole: r }));
    if (r === 'turista') setScreen('catalog');
    else if (r === 'barqueiro') setScreen('barqueiro');
    else if (r === 'guia') setScreen('guia');
    else if (r === 'artesa') setScreen('artesa');
    else if (r === 'cozinheira') setScreen('cozinheira');
  };

  const toggleTheme = () => {
    setData((d) => ({ ...d, theme: d.theme === 'light' ? 'dark' : 'light' }));
  };

  const login = () => {
    setData((d) => ({ ...d, isLoggedIn: true }));
    setScreen('catalog');
  };

  const logout = () => {
    setData((d) => ({ ...d, isLoggedIn: false }));
    setScreen('login');
  };

  const selectExperience = (id: string) => {
    setData((d) => ({ ...d, selectedExperienceId: id }));
    setScreen('detail');
  };

  const addVoucher = (v: Voucher) => {
    setData((d) => ({ ...d, vouchers: [...d.vouchers, v] }));
  };

  const addBoatTrip = (t: BoatTrip) => {
    setData((d) => ({ ...d, boatTrips: [...d.boatTrips, t] }));
  };

  const addTrail = (t: Trail) => {
    setData((d) => ({ ...d, trails: [...d.trails, t] }));
  };

  const addCraft = (c: CraftItem) => {
    setData((d) => ({ ...d, crafts: [...d.crafts, c] }));
  };

  const addMeal = (m: Meal) => {
    setData((d) => ({ ...d, meals: [...d.meals, m] }));
  };

  const updateMealReserved = (id: string, reserved: number) => {
    setData((d) => ({
      ...d,
      meals: d.meals.map((m) => (m.id === id ? { ...m, reserved } : m)),
    }));
  };

  return (
    <AppContext.Provider
      value={{
        data,
        screen,
        setScreen,
        setRole,
        toggleTheme,
        login,
        logout,
        selectExperience,
        addVoucher,
        addBoatTrip,
        addTrail,
        addCraft,
        addMeal,
        updateMealReserved,
      }}
    >
      {children}
    </AppContext.Provider>
  );
}

export function useApp() {
  const ctx = useContext(AppContext);
  if (!ctx) throw new Error('useApp must be used within AppProvider');
  return ctx;
}
