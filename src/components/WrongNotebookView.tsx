import React from 'react';
import { ArrowLeft, BookmarkX, CheckCircle, Trash2, BookOpen } from 'lucide-react';
import { Question } from '../types';

interface WrongNotebookViewProps {
  questions: Question[];
  onBack: () => void;
  onRemoveFromNotebook: (questionId: string) => void;
}

export const WrongNotebookView: React.FC<WrongNotebookViewProps> = ({
  questions,
  onBack,
  onRemoveFromNotebook,
}) => {
  return (
    <div className="p-4 sm:p-5 max-w-2xl mx-auto space-y-4">
      <div className="flex items-center justify-between">
        <button
          onClick={onBack}
          className="flex items-center gap-1.5 text-xs text-slate-400 hover:text-white p-1 rounded-lg transition-colors cursor-pointer"
        >
          <ArrowLeft className="w-4 h-4" />
          <span>Geri</span>
        </button>

        <h3 className="font-bold text-sm text-white">Yanlış Defteri ({questions.length})</h3>
        <div className="w-12" />
      </div>

      {questions.length === 0 ? (
        <div className="p-8 text-center bg-slate-900 border border-slate-800 rounded-2xl space-y-3">
          <div className="w-14 h-14 mx-auto bg-emerald-950/40 text-emerald-400 border border-emerald-800 rounded-full flex items-center justify-center text-2xl">
            ✓
          </div>
          <h4 className="font-bold text-white text-base">Tebrikler, Defterin Boş!</h4>
          <p className="text-xs text-slate-400 max-w-xs mx-auto">
            Test çözerken yanlış yaptığınız sorular burada toplanır. Şu anda yanlışınız bulunmuyor.
          </p>
        </div>
      ) : (
        <div className="space-y-3">
          <p className="text-xs text-slate-400">
            Hatalarınızı analiz ederek eksiklerinizi kalıcı şekilde tamamlayın.
          </p>

          {questions.map((q) => (
            <div
              key={q.id}
              className="bg-slate-900 border border-slate-800 rounded-xl p-4 space-y-3 shadow-sm"
            >
              <div className="flex items-center justify-between">
                <span className="text-xs font-bold text-red-400 bg-red-950/60 px-2 py-0.5 rounded border border-red-900/60">
                  {q.subject} • {q.subCategory}
                </span>
                <button
                  onClick={() => onRemoveFromNotebook(q.id)}
                  title="Öğrendim, Defterden Çıkar"
                  className="text-slate-400 hover:text-emerald-400 text-xs flex items-center gap-1 p-1 hover:bg-slate-800 rounded transition-colors cursor-pointer"
                >
                  <CheckCircle className="w-3.5 h-3.5" />
                  <span>Öğrendim</span>
                </button>
              </div>

              <p className="text-sm font-medium text-slate-200 leading-relaxed">
                {q.questionText}
              </p>

              <div className="bg-slate-950/60 border border-slate-800/80 rounded-lg p-3 text-xs text-slate-300 space-y-1">
                <div className="font-bold text-emerald-400">
                  Doğru Cevap: {q.options[q.correctIndex]}
                </div>
                <div className="text-slate-400 leading-relaxed">{q.explanation}</div>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
};
