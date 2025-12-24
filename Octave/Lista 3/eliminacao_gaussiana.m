%% ========== FUNÇÃO PRINCIPAL ==========
function eliminacao_gaussiana()
    clc;
    clear;
    close all;

    % [MODIFICAR AQUI] Matriz A e vetor b conforme a questão

    % Questão 1:
    %A = [1 6 3 -3;
    %     2 7 1 2;
    %     1 5 3 -3;
    %     0 -6 -2 3];
    %b = [2; 5; 3; 6];

    % Questão 2:
    %A = [3 2 0;
    %     3 2 1;
    %     2 1 3];
    %b = [13; 13; 9];

    % Questão 3:
    % A = [-1 1 -3;
    %      3 -2 8;
    %      2 -2 5];
    % b = [-4; 14; 7];

    % Questão 4:
    % A = [3 5 -5;
    %      -4 8 -5;
    %      2 -5 6];
    % b = [21; 1; -16];

    % Questão 5:
    % A = [2 0 1;
    %      5 -1 1;
    %      -1 2 2];
    % b = [2; 5; 0];

    % Questão 6:
    A = [4 3 1;
         6 1 0;
         3 5 3];
    b = [14; 9; 21];

    % Questão 7:
    % A = [1 1 -3;
    %      2 0 1;
    %      -7 -2 1];
    % b = [-17; 12; -11];

    % Questão 8:
    %A = [0.780 0.563;
    %     0.913 0.659];
    %b = [0.217; 0.254];

    fprintf('========================================\n');
    fprintf('ELIMINAÇÃO GAUSSIANA COM PIVOTAMENTO\n');
    fprintf('========================================\n\n');

    % Exibir sistema original
    exibir_sistema(A, b);

    % Resolver o sistema
    [x, sucesso] = metodo_eliminacao_gaussiana(A, b);

    % Exibir resultados
    exibir_resultados(x, A, b, sucesso);
end

%% ========== MÉTODO DE ELIMINAÇÃO GAUSSIANA ==========
function [x, sucesso] = metodo_eliminacao_gaussiana(A, b)
    % Criar matriz aumentada [A | b]
    Aa = [A b];
    n = size(A, 1);

    fprintf('----------------------------------------\n');
    fprintf('FASE 1: ELIMINAÇÃO (Triangular Superior)\n');
    fprintf('----------------------------------------\n\n');

    % Fase de Eliminação com Pivotamento Parcial
    for k = 1:n-1
        % Pivotamento parcial
        [Aa, trocou] = pivotamento_parcial(Aa, k);

        if trocou
            fprintf('Iteração %d: Pivotamento realizado\n', k);
        else
            fprintf('Iteração %d: Sem troca de linhas\n', k);
        end

        % Eliminação abaixo do pivô
        for i = k+1:n
            if Aa(k, k) == 0
                fprintf('\n✗ ERRO: Pivô zero encontrado!\n');
                x = zeros(n, 1);
                sucesso = false;
                return;
            end

            % Calcular multiplicador
            m = Aa(i, k) / Aa(k, k);

            % Eliminar elemento abaixo do pivô
            Aa(i, :) = Aa(i, :) - m * Aa(k, :);
        end

        fprintf('Matriz após iteração %d:\n', k);
        exibir_matriz_aumentada(Aa);
        fprintf('\n');
    end

    fprintf('----------------------------------------\n');
    fprintf('FASE 2: SUBSTITUIÇÃO REGRESSIVA\n');
    fprintf('----------------------------------------\n\n');

    % Substituição Regressiva
    x = zeros(n, 1);

    for i = n:-1:1
        if Aa(i, i) == 0
            fprintf('\n✗ ERRO: Pivô zero na substituição!\n');
            sucesso = false;
            return;
        end

        % Calcular x(i)
        soma = 0;
        for j = i+1:n
            soma = soma + Aa(i, j) * x(j);
        end
        x(i) = (Aa(i, n+1) - soma) / Aa(i, i);

        fprintf('x%d = %.6f\n', i, x(i));
    end

    fprintf('\n');
    sucesso = true;
end

%% ========== PIVOTAMENTO PARCIAL ==========
function [Aa, trocou] = pivotamento_parcial(Aa, k)
    n = size(Aa, 1);

    % Encontrar o maior elemento (em módulo) na coluna k, da linha k em diante
    [~, max_idx] = max(abs(Aa(k:n, k)));
    max_idx = max_idx + k - 1;

    % Trocar linhas se necessário
    if max_idx ~= k
        aux = Aa(k, :);
        Aa(k, :) = Aa(max_idx, :);
        Aa(max_idx, :) = aux;
        trocou = true;
    else
        trocou = false;
    end
end

%% ========== EXIBIR SISTEMA ORIGINAL ==========
function exibir_sistema(A, b)
    n = size(A, 1);
    m = size(A, 2);

    fprintf('Sistema de equações:\n\n');

    for i = 1:n
        fprintf('  ');
        for j = 1:m
            coef = A(i, j);

            % Formatação do coeficiente
            if j == 1
                if coef >= 0
                    fprintf('%6.3fx%d', coef, j);
                else
                    fprintf('%6.3fx%d', coef, j);
                end
            else
                if coef >= 0
                    fprintf(' + %6.3fx%d', coef, j);
                else
                    fprintf(' - %6.3fx%d', abs(coef), j);
                end
            end
        end
        fprintf(' = %7.3f\n', b(i));
    end

    fprintf('\n');
end

%% ========== EXIBIR MATRIZ AUMENTADA ==========
function exibir_matriz_aumentada(Aa)
    [n, m] = size(Aa);

    for i = 1:n
        fprintf('  [ ');
        for j = 1:m-1
            fprintf('%8.4f ', Aa(i, j));
        end
        fprintf('| %8.4f ]\n', Aa(i, m));
    end
end

%% ========== EXIBIR RESULTADOS ==========
function exibir_resultados(x, A, b, sucesso)
    fprintf('========================================\n');
    fprintf('RESULTADOS FINAIS\n');
    fprintf('========================================\n\n');

    if sucesso
        fprintf('✓ Solução encontrada com sucesso!\n\n');
    else
        fprintf('✗ Não foi possível encontrar a solução!\n\n');
        return;
    end

    fprintf('Solução do sistema:\n\n');
    n = length(x);
    for i = 1:n
        fprintf('  x%d = %.6f\n', i, x(i));
    end

    fprintf('\n----------------------------------------\n');
    fprintf('VERIFICAÇÃO: Ax = b\n');
    fprintf('----------------------------------------\n\n');

    % Verificar a solução
    resultado = A * x;
    erro = b - resultado;

    fprintf('Comparação:\n\n');
    fprintf('  b (esperado)    |  Ax (calculado)  |  Erro\n');
    fprintf('  ------------------------------------------------\n');

    for i = 1:n
        fprintf('  %14.10f  |  %14.10f  |  %.2e\n', b(i), resultado(i), erro(i));
    end

    % Norma do erro
    norma_erro = norm(erro);
    fprintf('\n  Norma do erro: %.10e\n', norma_erro);

    if norma_erro < 1e-10
        fprintf('\n✓ Verificação: Solução correta!\n');
    elseif norma_erro < 1e-5
        fprintf('\n✓ Verificação: Solução aceitável (erro < 10^-5)\n');
    else
        fprintf('\n⚠ Atenção: Erro relativamente grande!\n');
    end

    fprintf('\n========================================\n');
end
