import { useState } from 'react';
import { useApp } from '../store';
import { Button } from '../components/Button';
import { Waves, Map, Mail, Lock, Chrome } from 'lucide-react';
import type { Role } from '../types';

const roleLabels: Record<Role, string> = {
  turista: 'Turista',
  barqueiro: 'Barqueiro',
  guia: 'Guia',
  artesa: 'Artesã',
  cozinheira: 'Cozinheira',
};

export function LoginScreen() {
  const { login, setRole } = useApp();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');

  return (
    <div className="flex flex-col min-h-full">
  {/* Top area */}
<div className="bg-white dark:bg-surface-dark p-[10px] flex items-center justify-center">
  {/* Imagem para o Modo Claro */}
  <img 
    src="/logo-light.jpg" 
    alt="Banzeiro Tour" 
    className="w-full h-auto max-h-56 object-contain rounded-[10px] dark:hidden" 
  />

  {/* Imagem para o Modo Escuro */}
  <img 
    src="/logo-dark.jpg" 
    alt="Banzeiro Tour" 
    className="w-full h-auto max-h-56 object-contain rounded-[10px] hidden dark:block" 
  />
</div>

      {/* Bottom sheet */}
      <div className="flex-1 bg-primary-600 rounded-t-[32px] px-7 pt-8 pb-6 flex flex-col text-white">
        <h2 className="font-heading text-2xl font-bold mb-1">Bem-vindo!</h2>
        <p className="text-white/70 text-sm mb-6">Explore a Amazônia com responsabilidade</p>

        <div className="space-y-3 mb-5">
          <div className="relative">
            <Mail size={18} className="absolute left-4 top-1/2 -translate-y-1/2 text-white/40" />
            <input
              type="email"
              placeholder="seu@email.com"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              className="w-full bg-white/10 border border-white/20 rounded-2xl pl-12 pr-4 py-3.5 text-white placeholder-white/40 text-sm focus:outline-none focus:border-accent-300 transition-colors min-h-[48px]"
            />
          </div>
          <div className="relative">
            <Lock size={18} className="absolute left-4 top-1/2 -translate-y-1/2 text-white/40" />
            <input
              type="password"
              placeholder="Senha"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              className="w-full bg-white/10 border border-white/20 rounded-2xl pl-12 pr-4 py-3.5 text-white placeholder-white/40 text-sm focus:outline-none focus:border-accent-300 transition-colors min-h-[48px]"
            />
          </div>
        </div>

        <Button variant="white" fullWidth size="lg" icon={<Map size={20} />} onClick={login}>
          Entrar
        </Button>

        <button className="w-full flex items-center justify-center gap-2 mt-3 py-3.5 rounded-2xl border-2 border-white/30 text-white font-bold text-sm hover:bg-white/10 transition-colors min-h-[48px]">
          <Chrome size={20} />
          Entrar com Google
        </button>

        <div className="mt-6">
          <p className="text-white/50 text-xs text-center mb-3 font-semibold uppercase tracking-wider">
            Acesso rápido para demonstração
          </p>
          <div className="flex flex-wrap gap-2 justify-center">
            {(Object.keys(roleLabels) as Role[]).map((r) => (
              <button
                key={r}
                onClick={() => setRole(r)}
                className="px-4 py-2 rounded-full bg-white/10 text-white text-xs font-bold hover:bg-accent-500 transition-colors min-h-[36px]"
              >
                {roleLabels[r]}
              </button>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}
