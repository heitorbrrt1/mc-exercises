%% ========== FUNÇÃO PRINCIPAL ==========
function newton_raphson_2D()
    clc;
    clear;
    close all;

    % [MODIFICAR AQUI] Condições iniciais conforme a questão
    % x0 = [10; 5];  % Questão 1
    % x0 = [1; 1];  % Questões 2, 3, 4
    x0 = [1.5; 3.5];  % Questões 5, 6
    % x0 = [1.5; 4];  % Questão 8

    tol = 1e-5;
    max_iter = 1000;

    fprintf('========================================\n');
    fprintf('MÉTODO DE NEWTON-RAPHSON (2D)\n');
    fprintf('Sistema de Equações Não-Lineares\n');
    fprintf('========================================\n\n');

    fprintf('Condições iniciais:\n');
    fprintf('x1 = %.6f\n', x0(1));
    fprintf('x2 = %.6f\n\n', x0(2));

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
    fprintf('x2 = %.6f\n\n', x_sol(2));

    fprintf('Verificação F(x) ≈ 0:\n');
    F_final = sistema_equacoes(x_sol);
    fprintf('f1(x) = %.10f\n', F_final(1));
    fprintf('f2(x) = %.10f\n\n', F_final(2));

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

        % Resolver o sistema J * delta_x = -F
        delta_x = J \ (-F);

        % Atualizar a solução
        x_novo = x + delta_x;

        historico(:, k+1) = x_novo;

        % Calcular erro
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

    % [MODIFICAR AQUI] Equações conforme a questão

    % Questão 1:
    % f1 = 4*x1 + x2 - sqrt(x2^3) - 0.25;
    % f2 = 8*x1^2 + 16*x2 - 8*x1*x2 - 5;

    % Questão 2:
    % f1 = 2*x1^2 - 4*x1*x2 - x2^2;
    % f2 = 2*x2^2 + 10*x1 - x1^2 - 4*x1*x2 - 5;

    % Questão 3:
    % f1 = 2*x1 - 4*x1*x2 + 2*x2^2;
    % f2 = 3*x2^2 + 6*x1 - x1^2 - 4*x1*x2 - 5;

    % Questão 4:
    % f1 = x1 + x2 - sqrt(x2) - 0.25;
    % f2 = 8*x1^2 + 16*x2 - 8*x1*x2 - 10;

    % Questão 5:
    f1 = x1^2*x2 + cos(x1*x2) - 4;
    f2 = 4*x1^3*x2^2 - 8*x2^3 + 16*x1^2 - 31*x2^2;

    % Questão 6:
    % f1 = x1*sin(x1) + x2;
    % f2 = 4*x1^3*cos(x2)^2;

    % Questão 8:
    % f1 = x1^2 - x2 + 1;
    % f2 = x1^2 + (1/4)*x2^2 - 1;

    F = [f1; f2];
end

%% ========== MATRIZ JACOBIANA ==========
function J = matriz_jacobiana(x)
    x1 = x(1);
    x2 = x(2);

    % [MODIFICAR AQUI] Derivadas parciais conforme a questão

    % Questão 1:
    % df1_dx1 = 4;
    % df1_dx2 = 1 - 1.5 * sqrt(x2);
    % df2_dx1 = 16*x1 - 8*x2;
    % df2_dx2 = 16 - 8*x1;

    % Questão 2:
    % df1_dx1 = 4*x1 - 4*x2;
    % df1_dx2 = -4*x1 - 2*x2;
    % df2_dx1 = 10 - 2*x1 - 4*x2;
    % df2_dx2 = 4*x2 - 4*x1;

    % Questão 3:
    % df1_dx1 = 2 - 4*x2;
    % df1_dx2 = -4*x1 + 4*x2;
    % df2_dx1 = 6 - 2*x1 - 4*x2;
    % df2_dx2 = 6*x2 - 4*x1;

    % Questão 4:
    % df1_dx1 = 1;
    % df1_dx2 = 1 - 1/(2*sqrt(x2));
    % df2_dx1 = 16*x1 - 8*x2;
    % df2_dx2 = 16 - 8*x1;

    % Questão 5:
    df1_dx1 = 2*x1*x2 - x2*sin(x1*x2);
    df1_dx2 = x1^2 - x1*sin(x1*x2);
    df2_dx1 = 12*x1^2*x2^2 + 32*x1;
    df2_dx2 = 8*x1^3*x2 - 24*x2^2 - 62*x2;

    % Questão 6:
    % df1_dx1 = sin(x1) + x1*cos(x1);
    % df1_dx2 = 1;
    % df2_dx1 = 12*x1^2*cos(x2)^2;
    % df2_dx2 = -8*x1^3*cos(x2)*sin(x2);

    % Questão 8:
    % df1_dx1 = 2*x1;
    % df1_dx2 = -1;
    % df2_dx1 = 2*x1;
    % df2_dx2 = (1/2)*x2;

    J = [df1_dx1, df1_dx2;
         df2_dx1, df2_dx2];
end

%% ========== GRÁFICO DE CONVERGÊNCIA ==========
function grafico_convergencia(historico)
    [~, n_iter] = size(historico);
    iteracoes = 0:(n_iter-1);

    figure('Name', 'Convergência das Variáveis', 'Position', [100, 100, 1200, 400]);

    % Convergência de x1
    subplot(1, 2, 1);
    plot(iteracoes, historico(1, :), 'b-o', 'LineWidth', 2, 'MarkerSize', 6);
    xlabel('Iteração', 'FontSize', 12);
    ylabel('x_1', 'FontSize', 12);
    title('Convergência de x_1', 'FontSize', 14);
    grid on;

    % Convergência de x2
    subplot(1, 2, 2);
    plot(iteracoes, historico(2, :), 'r-o', 'LineWidth', 2, 'MarkerSize', 6);
    xlabel('Iteração', 'FontSize', 12);
    ylabel('x_2', 'FontSize', 12);
    title('Convergência de x_2', 'FontSize', 14);
    grid on;

    sgtitle('Análise de Convergência - Newton-Raphson 2D', ...
            'FontSize', 16, 'FontWeight', 'bold');
end

%% ========== ANIMAÇÃO DA TRAJETÓRIA (SIMPLIFICADA) ==========
function grafico_animacao(historico)
    [~, n_iter] = size(historico);

    % Cria matriz todosX com duas colunas [x1, x2]
    todosX = [historico(1, :)', historico(2, :)'];

    figure('Name', 'Animação da Trajetória no Plano x1-x2', ...
           'Position', [100, 100, 900, 700]);

    fprintf('   Animando %d iterações (aguarde)...\n', n_iter);

    % Definir limites do gráfico com margem
    x1_min = min(todosX(:,1));
    x1_max = max(todosX(:,1));
    x2_min = min(todosX(:,2));
    x2_max = max(todosX(:,2));

    margin_x1 = 0.2 * (x1_max - x1_min);
    margin_x2 = 0.2 * (x2_max - x2_min);

    if margin_x1 < 0.1
        margin_x1 = 0.5;
    end
    if margin_x2 < 0.1
        margin_x2 = 0.5;
    end

    % Animação iteração por iteração
    for k = 1:n_iter
        clf;
        hold on;

        % Plota a trajetória até o ponto atual em azul
        if k > 1
            plot(todosX(1:k,1), todosX(1:k,2), 'b-', 'LineWidth', 2.5, ...
                 'DisplayName', 'Trajetória percorrida');
        end

        % Ponto inicial (verde)
        plot(todosX(1,1), todosX(1,2), 'go', 'MarkerSize', 12, ...
             'MarkerFaceColor', 'g', 'LineWidth', 2, 'DisplayName', 'Início');

        % Ponto atual (vermelho - destaque)
        plot(todosX(k,1), todosX(k,2), 'ro', 'MarkerSize', 14, ...
             'MarkerFaceColor', 'r', 'LineWidth', 2, 'DisplayName', 'Atual');

        % Solução final (apenas na última iteração)
        if k == n_iter
            plot(todosX(end,1), todosX(end,2), 'ms', 'MarkerSize', 16, ...
                 'MarkerFaceColor', 'm', 'LineWidth', 2, 'DisplayName', 'Solução');
        end

        xlabel('x_1', 'FontSize', 13, 'FontWeight', 'bold');
        ylabel('x_2', 'FontSize', 13, 'FontWeight', 'bold');

        % Título com informações da iteração
        if k == n_iter
            title(sprintf('CONVERGÊNCIA! (Iteração %d)\nx_1 = %.6f, x_2 = %.6f', ...
                  k-1, todosX(k,1), todosX(k,2)), ...
                  'FontSize', 14, 'FontWeight', 'bold', 'Color', [0.8 0 0.8]);
        else
            title(sprintf('Iteração %d/%d\nx_1 = %.6f, x_2 = %.6f', ...
                  k-1, n_iter-1, todosX(k,1), todosX(k,2)), ...
                  'FontSize', 14, 'FontWeight', 'bold');
        end

        grid on;
        legend('Location', 'northeast', 'FontSize', 10);
        xlim([x1_min - margin_x1, x1_max + margin_x1]);
        ylim([x2_min - margin_x2, x2_max + margin_x2]);

        hold off;
        drawnow;

        % Pausa maior na última iteração
        if k == n_iter
            pause(2.0);
        else
            pause(0.8);
        end
    end

    fprintf('\n✓ Animação concluída!\n');
end
