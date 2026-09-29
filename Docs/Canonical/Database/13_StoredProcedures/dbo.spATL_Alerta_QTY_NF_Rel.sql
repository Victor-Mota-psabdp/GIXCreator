SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[spATL_Alerta_QTY_NF_Rel]
as
select 
'Alerta - Quantidade Nota Fiscal' Interface,
'' Ref_Cliente,
''Mensagem,
''Tabela,
--'tatiane.feitosa@bdpint.com;cesar.silva@bdpint.com' [strDestinatario],
'luciele.oliveira@bdpint.com;bruno.barreto@bdpint.com'  [strDestinatario],
'Alerta - Quantidade Nota Fiscal ' [strAssunto],
'JOB : ' + N.Num_Proc + '|' + 
'Qty NF: ' + cast(COUNT(Nota_Fiscal) as varchar(500)) + '|' + 
'|||||||' +'Sent by BDP System' [strCorpoMSG],
NULL,
GETDATE(),
NULL,
NULL,
'' [strAnexoCaminho],
--'tatiane.feitosa@bdpint.com' [strResponderPara] 
'luciele.oliveira@bdpint.com' [strResponderPara]
 from Nota_Cliente N with(nolock)
join vwCliente C with(nolock) on N.Num_Proc = C.num_proc
where Emissao > = GETDATE() -120
group by N.Num_Proc
having COUNT(Nota_Fiscal) >1

union all

select 
'Alerta - Quantidade Nota Fiscal' Interface,
'' Ref_Cliente,
'' Mensagem,
'' Tabela,
--'tatiane.feitosa@bdpint.com;cesar.silva@bdpint.com' [strDestinatario],
'luciele.oliveira@bdpint.com;bruno.barreto@bdpint.com'   [strDestinatario],
'Alerta - Quantidade Nota Fiscal ' [strAssunto],
'JOB : ' + N.Num_Proc + '|' + 
'Itens da Nota Fisca não encontrado!' +'|' + 
'|||||||' +'Sent by BDP System' [strCorpoMSG],
NULL,
GETDATE(),
NULL,
NULL,
'' [strAnexoCaminho],
--'tatiane.feitosa@bdpint.com' [strResponderPara] 
'luciele.oliveira@bdpint.com' [strResponderPara]
 from Nota_Cliente N with(nolock)
join vwCliente C with(nolock) on N.Num_Proc = C.num_proc
left join Nota_Fiscal_Cliente_Det ND with(nolock) on ND.ID_NF = N.ID_NF and ND.Cd_Cliente = nd.Cd_Cliente
where Emissao > = GETDATE() -120 and ND.ID_Item is null
group by N.Num_Proc


GO
