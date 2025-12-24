%% ========== FUNÇÃO PRINCIPAL ==========
function newton_raphson()
    clc;
    clear;
    close all;

    % Questão 7:
    % x0 = [1; 2; 3];

    % Questão 9:
    x0 = [0.5; 1; 0];

    tol = 1e-5;
    max_iter = 1000;

    fprintf('========================================\n');
    fprintf('MÉTODO DE NEWTON-RAPHSON\n');
    fprintf('Sistema de Equações Não-Lineares\n');
    fprintf('========================================\n\n');

    fprintf('Condições iniciais:\n');
    fprintf('x1 = %.6f\n', x0(1));
    fprintf('x2 = %.6f\n', x0(2));
    fprintf('x3 = %.6f\n\n', x0(3));

    fprintf('Tolerância: %.0e\n', tol);
    fprintf('Máximo de iterações: %d\n\n', max_iter);

    [x_sol, historico, n_iter, convergiu] = metodo_newton_raphson(x0, tol, max_iter);

    fprintf('========================================\n');
    fprintf('RESULTADOS\n');
    fprintf('========================================\n\n');

    if convergiu
        fprintf('✓ Convergência alcançada!\n\n');
    else
        fprintf('✗ Não convergiu no número máximo de iterações!\n\n');
    end

    fprintf('Número de iterações: %d\n\n', n_iter);

    fprintf('Solução encontrada:\n');
    fprintf('x1 = %.6f\n', x_sol(1));
    fprintf('x2 = %.6f\n', x_sol(2));
    fprintf('x3 = %.6f\n\n', x_sol(3));

    fprintf('Verificação F(x) ≈ 0:\n');
    F_final = sistema_equacoes(x_sol);
    fprintf('f1(x) = %.10f\n', F_final(1));
    fprintf('f2(x) = %.10f\n', F_final(2));
    fprintf('f3(x) = %.10f\n\n', F_final(3));

    fprintf('========================================\n');
    fprintf('GERANDO GRÁFICOS\n');
    fprintf('========================================\n\n');

    fprintf('>> Iniciando animação da trajetória...\n');
    fprintf('   (Observe a janela "Animação da Trajetória")\n\n');
    grafico_animacao(historico);

    fprintf('>> Gerando gráficos de convergência...\n\n');
    grafico_convergencia(historico);

    fprintf('✓ Todos os gráficos foram gerados!\n');
end

%% ========== MÉTODO DE NEWTON-RAPHSON ==========
function [x_sol, historico, n_iter, convergiu] = metodo_newton_raphson(x0, tol, max_iter)
    x = x0;
    n = length(x0);
    historico = zeros(n, max_iter+1);
    historico(:, 1) = x;
    convergiu = false;

    for k = 1:max_iter
        F = sistema_equacoes(x);
        J = matriz_jacobiana(x);

        delta_x = J \ (-F);

        x_novo = x + delta_x;

        historico(:, k+1) = x_novo;

        erro = norm(delta_x);

        if erro < tol
            convergiu = true;
            n_iter = k;
            historico = historico(:, 1:k+1);
            x_sol = x_novo;
            return;
        end

        x = x_novo;
    end

    n_iter = max_iter;
    historico = historico(:, 1:max_iter+1);
    x_sol = x;
end

%% ========== SISTEMA DE EQUAÇÕES ==========
function F = sistema_equacoes(x)
    x1 = x(1);
    x2 = x(2);
    x3 = x(3);

    % --- Questão 7 ---
    % f1 = 2*x1 - x2 - cos(x1);
    % f2 = -x1 + 2*x2 - x3 - cos(x2);
    % f3 = -x2 + x3 - cos(x3);

    % --- Questão 9 ---
    f1 = 6*x1 - 2*x2 + exp(x3) - 2;
    f2 = sin(x1) - x2 + x3;
    f3 = sin(x1) + 2*x2 + 3*x3 - 1;

    F = [f1; f2; f3];
end

%% ========== MATRIZ JACOBIANA ==========
function J = matriz_jacobiana(x)
    x1 = x(1);
    x2 = x(2);
    x3 = x(3);

    % --- Questão 7 ---
    % df1_dx1 = 2 + sin(x1);  df1_dx2 = -1;           df1_dx3 = 0;
    % df2_dx1 = -1;           df2_dx2 = 2 + sin(x2);  df2_dx3 = -1;
    % df3_dx1 = 0;            df3_dx2 = -1;           df3_dx3 = 1 + sin(x3);

    % --- Questão 9 ---
    df1_dx1 = 6;            df1_dx2 = -2;           df1_dx3 = exp(x3);
    df2_dx1 = cos(x1);      df2_dx2 = -1;           df2_dx3 = 1;
    df3_dx1 = cos(x1);      df3_dx2 = 2;            df3_dx3 = 3;

    J = [df1_dx1, df1_dx2, df1_dx3;
         df2_dx1, df2_dx2, df2_dx3;
         df3_dx1, df3_dx2, df3_dx3];
end

%% ========== GRÁFICO DE CONVERGÊNCIA ==========
function grafico_convergencia(historico)
    [~, n_iter] = size(historico);
    iteracoes = 0:(n_iter-1);

    figure('Name', 'Convergência das Variáveis', 'Position', [100, 100, 1200, 400]);

    subplot(1, 3, 1);
    plot(iteracoes, historico(1, :), 'b-o', 'LineWidth', 2, 'MarkerSize', 6);
    xlabel('Iteração', 'FontSize', 12);
    ylabel('x_1', 'FontSize', 12);
    title('Convergência de x_1', 'FontSize', 14);
    grid on;

    subplot(1, 3, 2);
    plot(iteracoes, historico(2, :), 'r-o', 'LineWidth', 2, 'MarkerSize', 6);
    xlabel('Iteração', 'FontSize', 12);
    ylabel('x_2', 'FontSize', 12);
    title('Convergência de x_2', 'FontSize', 14);
    grid on;

    subplot(1, 3, 3);
    plot(iteracoes, historico(3, :), 'g-o', 'LineWidth', 2, 'MarkerSize', 6);
    xlabel('Iteração', 'FontSize', 12);
    ylabel('x_3', 'FontSize', 12);
    title('Convergência de x_3', 'FontSize', 14);
    grid on;
end

%% ========== ANIMAÇÃO DA TRAJETÓRIA ==========
function grafico_animacao(historico)
    [~, n_iter] = size(historico);

    x1_hist = historico(1, :);
    x2_hist = historico(2, :);
    x3_hist = historico(3, :);

    fig = figure('Name', 'Animação da Trajetória', 'Position', [100, 100, 1400, 450]);
    fprintf('   Animando %d iterações (aguarde)...\n', n_iter);

    planos = {
        struct('x', x1_hist, 'y', x2_hist, 'xlabel', 'x_1', 'ylabel', 'x_2', 'titulo', 'Plano x_1-x_2');
        struct('x', x1_hist, 'y', x3_hist, 'xlabel', 'x_1', 'ylabel', 'x_3', 'titulo', 'Plano x_1-x_3');
        struct('x', x2_hist, 'y', x3_hist, 'xlabel', 'x_2', 'ylabel', 'x_3', 'titulo', 'Plano x_2-x_3')
    };

    % Animação
    for k = 1:n_iter
        for p = 1:3
            subplot(1, 3, p);

            plot(planos{p}.x(1:k), planos{p}.y(1:k), 'b-', 'LineWidth', 1.5);
            hold on;

            plot(planos{p}.x(1), planos{p}.y(1), 'go', 'MarkerSize', 10, 'MarkerFaceColor', 'g', 'DisplayName', 'Início');

            plot(planos{p}.x(k), planos{p}.y(k), 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r', 'DisplayName', 'Atual');

            if k == n_iter
                plot(planos{p}.x(end), planos{p}.y(end), 'ms', 'MarkerSize', 12, 'MarkerFaceColor', 'm', 'DisplayName', 'Solução');
            end

            xlabel(planos{p}.xlabel, 'FontSize', 12);
            ylabel(planos{p}.ylabel, 'FontSize', 12);
            title([planos{p}.titulo, sprintf(' - Iteração %d', k-1)], 'FontSize', 12);
            grid on;
            legend('Location', 'northeast');
            hold off;

            x_range = max(planos{p}.x) - min(planos{p}.x);
            y_range = max(planos{p}.y) - min(planos{p}.y);
            margin = 0.1;
            xlim([min(planos{p}.x) - margin*x_range, max(planos{p}.x) + margin*x_range]);
            ylim([min(planos{p}.y) - margin*y_range, max(planos{p}.y) + margin*y_range]);
        end

        drawnow;
        pause(1.0);
    end

    fprintf('\n✓ Animação concluída!\n');
end
