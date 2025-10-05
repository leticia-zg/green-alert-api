package br.com.fiap.monitor_tree_api.config;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import br.com.fiap.monitor_tree_api.service.TokenService;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Component
public class AuthFilter extends OncePerRequestFilter {

    @Autowired
    private TokenService tokenService;

    // rotas públicas que NÃO devem passar pela validação de JWT
    private static final Set<String> PUBLIC_PATHS = Set.of(
        "/login",
        "/auth/login",
        "/swagger-ui",
        "/v3/api-docs",
        "/actuator/health",
        "/error"
    );

    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) throws ServletException {
        String path = request.getServletPath();
        if ("OPTIONS".equalsIgnoreCase(request.getMethod())) return true; // preflight
        // libera se o path começar com algum dos públicos
        return PUBLIC_PATHS.stream().anyMatch(p ->
            path.equals(p) || path.startsWith(p + "/")
        );
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain)
            throws ServletException, IOException {

        String header = request.getHeader("Authorization");

        // requisição anônima (sem Authorization) -> segue como anônima
        if (header == null || header.isBlank()) {
            filterChain.doFilter(request, response);
            return;
        }

        if (!header.startsWith("Bearer ")) {
            write401(response, "{ \"message\": \"O header Authorization deve começar com 'Bearer '\" }");
            return;
        }

        String jwt = header.substring("Bearer ".length()).trim();
        try {
            var user = tokenService.getUserFromToken(jwt);
            if (user == null) {
                write401(response, "{ \"message\": \"Token inválido ou expirado\" }");
                return;
            }

            var authentication =
                new UsernamePasswordAuthenticationToken(user, null, user.getAuthorities());
            SecurityContextHolder.getContext().setAuthentication(authentication);
            filterChain.doFilter(request, response);

        } catch (Exception ex) {
            write401(response, "{ \"message\": \"Token inválido ou expirado\" }");
        }
    }

    private void write401(HttpServletResponse response, String body) throws IOException {
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        response.setContentType(MediaType.APPLICATION_JSON_VALUE);
        response.setCharacterEncoding(StandardCharsets.UTF_8.name());
        response.getWriter().write(body);
    }
}
