%insult_user.m
function insult_user
% user insult database
        insults={'moron', 'idiot', 'imbecile', 'cretin', 'dolt',...
            'simpleton', 'fool', 'stupid human', 'lamebrain', 'ninny',...
            'numbskull', 'nitwit', 'twerp', 'dingbat',...
            'ugly bag of mostly water', ...
            'miserable assemblage of carbon-based goop',...
            'disfunctional carbon unit'};
        num_insults=17;
        
        mercy=randperm(10);
        if mercy(1)==1
            % forgive user
            fprintf('to err is HUMAN, to forgive, computerlike\n');
        else
            % insult user
            choose=randperm(num_insults);
            fprintf('you %s!\n', insults{choose(1)});
        end;
end