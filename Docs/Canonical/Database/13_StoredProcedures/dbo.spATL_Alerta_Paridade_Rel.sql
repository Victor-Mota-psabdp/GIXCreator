SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_Alerta_Paridade_Rel]
as
select
'**Alerta - Paridade DI Zerada**' Interface,
'' Ref_Cliente,
''Mensagem,
''Tabela,
--' br.sao.qualidade@bdpint.com' [strDestinatario],
--'tatiane.feitosa@bdpint.com;cesar.silva@bdpint.com' [strDestinatario], 05/11/2019 - Cadu
--'luciele.oliveira@bdpint.com;bruno.barreto@bdpint.com;joyce.pereira@bdpint.com'   [strDestinatario],
'luciele.oliveira@bdpint.com;bruno.barreto@bdpint.com'   [strDestinatario],
'Alerta - Paridade DI Zerada' [strAssunto],
'JOB: ' + H.Num_Proc + '|' + 
'Data de Desembaraço:' + CONVERT(varchar(10),TP4.Dt_Conclusao,103) +'|'+
--'Qty NF: ' + cast(COUNT(Nota_Fiscal) as varchar(500)) + '|' + 
'|||||||' +'Sent by BDP System' [strCorpoMSG],
NULL,
GETDATE(),
NULL,
NULL,
'' [strAnexoCaminho],
--'br.sao.qualidade@bdpint.com' [strResponderPara] 
--'tatiane.feitosa@bdpint.com' [strResponderPara],
'luciele.oliveira@bdpint.com' [strResponderPara],
C.Campo_Dados 
 from Campo_Processo C with(nolock)
 join vwCliente H with(nolock) on C.Num_Proc = H.Num_Proc
-- join Pessoa_LLP P with(nolock) on H.cd_cliente = P.Cd_Pes
-- join Grupo G with(nolock) on P.Cd_Pes_Grupo = G.Cd_Pes_Grupo
 join Tarefas_Processos TP4 with(nolock) on C.Num_Proc = TP4.Num_Proc and TP4.ID_Task =4 
--join vwCliente C with(nolock) on N.Num_Proc = C.num_proc
where substring(C.Num_Proc,3,3) not in ('GVA','GVD','OXT','MDB') 
and TP4.Dt_Conclusao >= '2018-01-01' and SUBSTRING(C.Num_Proc,1,1)  = 'I' 
and  TP4.Dt_Conclusao is not null and Id_Campo = 31 and (C.Campo_Dados ='0' or ltrim(rtrim(C.Campo_Dados)) = '')





GO
