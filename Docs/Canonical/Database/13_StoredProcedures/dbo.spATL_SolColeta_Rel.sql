SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--spATL_SolColeta_Rel 'IMUPL201609065BR','ERBSON'
create procedure [dbo].[spATL_SolColeta_Rel]
(
@Num_Proc varchar(16),
@Cd_Usuario varchar(6)
)

as

Declare @Nome_Usuario varchar(50)
set @Nome_Usuario = (select Nome_Usuario from Usuario with(nolock) where Cd_Usuario = @Cd_Usuario)

Declare @NFMae varchar(500)
set @NFMae = (select  min(Numero_PO_HIM) from PO_HIM  with(nolock) where Num_Proc_HIM =@Num_Proc and ID_DC = 10)
Declare @NFFilho varchar(500)
select @NFFilho = COALESCE(@NFFilho + ' - ','') + Numero_PO_HIM from PO_HIM  with(nolock) where Num_Proc_HIM =@Num_Proc and Numero_PO_HIM not in(@NFMae) and ID_DC = 10

select 

HOU.Num_Proc [Nº],
CONVERT(VARCHAR,GETDATE(),103) [DATA],
@Nome_Usuario [SOLICITANTE],
@NFMae [NF MÃE],
@NFFilho [NF FILHOTE],
dbo.fBusca_Docs_PO_Modal_COALESCE(HOU.Num_Proc,'9') [PROCESSO],
dbo.fBusca_Docs_PO_Modal_COALESCE(HOU.Num_Proc,'5')[Nº DA DECLARAÇÃO DE IMPORTAÇÃO],
'BDP'[DESPACHANTE],
TRP.Apelido [TRANSPORTADOR],
T.Nome_Terminal [TERMINAL DE DEVOLUÇÃO],
 CONVERT(VARCHAR,CP131.Campo_Dados,103) [VENCIMENTO DA ARMAZENAGEM],
CONVERT(VARCHAR,DATEADD(day,CONVERT(int, CP138.Campo_Dados),HOU.ATA),103) [VENCIMENTO DE DEMURRAGE]
 from vwHOUSE_IMP HOU with(nolock)
 left join Pessoa TRP with(nolock) on HOU.Cd_Transportadora = TRP.Cd_Pes
 left join Campo_Processo CP3 with(nolock) on HOU.Num_Proc = CP3.Num_Proc and CP3.Id_Campo = 3
 left join Campo_Processo CP131 with(nolock) on HOU.Num_Proc = CP131.Num_Proc and CP131.Id_Campo = 131
 left join Campo_Processo CP138 with(nolock) on HOU.Num_Proc = CP138.Num_Proc and CP138.Id_Campo = 138
 left join Terminal T with(nolock) on CP3.Campo_Dados = T.Cd_Terminal
 where HOU.Num_Proc = @Num_Proc
 
 /*
 138
 select * from vwHouse_Imp
 select * from Campo_Processo
 where Id_Campo in ('102','105','156','157','158')
 
 select * from Tipo_Campo_Cliente
 where Descr_Campo like '%free%'
select * from Tipo_Campo_Cliente
where Descr_Campo like 'Venci%'
 
*/ 

GO
