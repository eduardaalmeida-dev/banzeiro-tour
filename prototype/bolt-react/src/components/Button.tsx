import type { ReactNode } from 'react';

interface ButtonProps {
  children: ReactNode;
  onClick?: () => void;
  variant?: 'primary' | 'accent' | 'outline' | 'white' | 'ghost' | 'danger';
  size?: 'sm' | 'md' | 'lg';
  fullWidth?: boolean;
  icon?: ReactNode;
  disabled?: boolean;
  className?: string;
}

export function Button({
  children,
  onClick,
  variant = 'accent',
  size = 'md',
  fullWidth = false,
  icon,
  disabled = false,
  className = '',
}: ButtonProps) {
  const base =
    'flex items-center justify-center gap-2 font-bold rounded-2xl transition-all duration-200 active:scale-[0.97] disabled:opacity-50 disabled:pointer-events-none';

  const variants = {
    primary: 'bg-primary-600 text-white hover:bg-primary-700 shadow-lg shadow-primary-600/20',
    accent: 'bg-accent-500 text-white hover:bg-accent-600 shadow-lg shadow-accent-500/20',
    outline:
      'border-2 border-primary-600 text-primary-600 dark:text-accent-300 dark:border-accent-400 hover:bg-primary-50 dark:hover:bg-primary-800/50',
    white: 'bg-white text-primary-600 hover:bg-gray-50 shadow-lg',
    ghost: 'text-primary-600 dark:text-accent-300 hover:bg-primary-50 dark:hover:bg-primary-800/50',
    danger: 'bg-error-500 text-white hover:bg-error-600 shadow-lg shadow-error-500/20',
  };

  const sizes = {
    sm: 'text-xs px-4 py-2.5 min-h-[40px]',
    md: 'text-sm px-5 py-3 min-h-[48px]',
    lg: 'text-base px-6 py-4 min-h-[52px]',
  };

  return (
    <button
      onClick={onClick}
      disabled={disabled}
      className={`${base} ${variants[variant]} ${sizes[size]} ${fullWidth ? 'w-full' : ''} ${className}`}
    >
      {icon}
      {children}
    </button>
  );
}
