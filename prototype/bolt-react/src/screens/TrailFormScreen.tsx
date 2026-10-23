import { useState } from 'react';
import { useApp } from '../store';
import { AppBar } from '../components/AppBar';
import { Button } from '../components/Button';
import { MapPin, Mountain, Clock, Users, Navigation } from 'lucide-react';

const levels = ['Leve', 'Moderada', 'Selva Densa'] as const;

export function TrailFormScreen() {
  const { addTrail, setScreen } = useApp();
  const [name, setName] = useState('');
  const [level, setLevel] = useState<(typeof levels)[number]>('Leve');
  const [duration, setDuration] = useState('');
  const [gps, setGps] = useState('');
  const [maxPeople, setMaxPeople] = useState(8);
  const [capturing, setCapturing] = useState(false);

  const captureGPS = () => {
    setCapturing(true);
    setTimeout(() => {
      const lat = (-3 + Math.random() * 0.1).toFixed(4);
      const lng = (-60 + Math.random() * 0.1).toFixed(4);
      setGps(`${lat}°, ${lng}°`);
      setCapturing(false);
    }, 1200);
  };

  const handleSubmit = () => {
    if (!name || !duration) return;
    addTrail({
      id: crypto.randomUUID(),
      name,
      level,
      duration,
      gps: gps || 'Não capturado',
      maxPeople,
    });
    setScreen('guia');
  };

  return (
    <div className="flex flex-col min-h-full bg-[#F8FAF8] dark:bg-primary-900">
      <AppBar title="Nova Trilha" showBack onBack={() => setScreen('guia')} />

      <div className="flex-1 px-5 py-5 overflow-y-auto no-scrollbar">
        <div className="space-y-4">
          {/* Nome */}
          <div>
            <label className="text-xs font-bold text-gray-500 dark:text-gray-400 uppercase mb-2 block">
              Nome da Trilha
            </label>
            <div className="relative">
              <Mountain size={18} className="absolute left-3.5 top-1/2 -translate-y-1/2 text-gray-400" />
              <input
                type="text"
                placeholder="ex: Trilha da Samaúma"
                value={name}
                onChange={(e) => setName(e.target.value)}
                className="w-full bg-white dark:bg-surface-dark rounded-2xl pl-11 pr-4 py-3.5 text-sm text-primary-700 dark:text-white border border-gray-200 dark:border-primary-700 focus:outline-none focus:ring-2 focus:ring-accent-400 placeholder-gray-400 min-h-[48px]"
              />
            </div>
          </div>

          {/* Nível */}
          <div>
            <label className="text-xs font-bold text-gray-500 dark:text-gray-400 uppercase mb-2 block">
              Nível
            </label>
            <div className="grid grid-cols-3 gap-2">
              {levels.map((lv) => (
                <button
                  key={lv}
                  onClick={() => setLevel(lv)}
                  className={`py-3 rounded-2xl text-xs font-bold transition-all min-h-[48px] ${
                    level === lv
                      ? 'bg-accent-500 text-white shadow-lg shadow-accent-500/20 scale-105'
                      : 'bg-white dark:bg-surface-dark text-gray-500 dark:text-gray-400 border border-gray-200 dark:border-primary-700'
                  }`}
                >
                  {lv}
                </button>
              ))}
            </div>
          </div>

          {/* Duração */}
          <div>
            <label className="text-xs font-bold text-gray-500 dark:text-gray-400 uppercase mb-2 block">
              Duração Estimada
            </label>
            <div className="relative">
              <Clock size={18} className="absolute left-3.5 top-1/2 -translate-y-1/2 text-gray-400" />
              <input
                type="text"
                placeholder="ex: 3h"
                value={duration}
                onChange={(e) => setDuration(e.target.value)}
                className="w-full bg-white dark:bg-surface-dark rounded-2xl pl-11 pr-4 py-3.5 text-sm text-primary-700 dark:text-white border border-gray-200 dark:border-primary-700 focus:outline-none focus:ring-2 focus:ring-accent-400 placeholder-gray-400 min-h-[48px]"
              />
            </div>
          </div>

          {/* GPS */}
          <div>
            <label className="text-xs font-bold text-gray-500 dark:text-gray-400 uppercase mb-2 block">
              Coordenadas GPS
            </label>
            <button
              onClick={captureGPS}
              disabled={capturing}
              className="w-full bg-white dark:bg-surface-dark rounded-2xl p-4 border-2 border-dashed border-accent-300 dark:border-accent-700 flex items-center justify-center gap-2 text-accent-600 dark:text-accent-300 font-bold text-sm hover:bg-accent-50 dark:hover:bg-accent-900/20 transition-colors min-h-[52px] disabled:opacity-50"
            >
              {capturing ? (
                <>
                  <Navigation size={18} className="animate-pulse" />
                  Capturando...
                </>
              ) : (
                <>
                  <MapPin size={18} />
                  {gps ? `GPS: ${gps}` : 'Capturar Coordenadas GPS (Sem Internet)'}
                </>
              )}
            </button>
          </div>

          {/* Limite */}
          <div>
            <label className="text-xs font-bold text-gray-500 dark:text-gray-400 uppercase mb-2 block">
              Limite de Pessoas
            </label>
            <div className="flex items-center gap-3">
              <div className="flex-1 bg-white dark:bg-surface-dark rounded-2xl py-3.5 text-center border border-gray-200 dark:border-primary-700 flex items-center justify-center gap-2">
                <Users size={16} className="text-gray-400" />
                <span className="font-heading text-xl font-extrabold text-primary-700 dark:text-white">
                  {maxPeople}
                </span>
              </div>
              <div className="flex gap-2">
                <button
                  onClick={() => setMaxPeople((v) => Math.max(1, v - 1))}
                  className="w-12 h-12 rounded-2xl bg-white dark:bg-surface-dark border border-gray-200 dark:border-primary-700 flex items-center justify-center text-primary-600 dark:text-accent-300 text-xl font-bold hover:bg-gray-50 dark:hover:bg-primary-800 transition-colors"
                >
                  −
                </button>
                <button
                  onClick={() => setMaxPeople((v) => Math.min(30, v + 1))}
                  className="w-12 h-12 rounded-2xl bg-white dark:bg-surface-dark border border-gray-200 dark:border-primary-700 flex items-center justify-center text-primary-600 dark:text-accent-300 text-xl font-bold hover:bg-gray-50 dark:hover:bg-primary-800 transition-colors"
                >
                  +
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div className="sticky bottom-0 bg-white dark:bg-surface-dark border-t border-gray-100 dark:border-primary-800 px-5 py-4 pb-6">
        <Button variant="accent" fullWidth size="lg" onClick={handleSubmit}>
          Publicar Trilha no Catálogo
        </Button>
      </div>
    </div>
  );
}
