SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--spATLINT_JSON_Oxiteno_updateSalesOrders_Sel null, null,null,'I'

CREATE procedure [dbo].[spATLINT_JSON_Oxiteno_updateSalesOrders_Sel]
(
	@ID_updateSalesOrders bigint,
	@numero_pedido varchar(200),
	@num_Proc varchar(200),
	@Tipo char(1)
)
as

/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codigo - Existentes
D, /// Busca pelo Codigo - Ativos
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Ativos
Z /// Verifica Nome X Codigo
sp_help Tipo_Modal
*/

if @Tipo = 'A' or @Tipo = 'B'
	Begin
		select 
			S.ID_updateSalesOrders [Internal Code],
			S.cd_pedido,
			S.numero_pedido,
			S.Num_Proc				[JOB],	
			S.booking,
			S.numero_viagem,
			S.navio,
			S.conhec_transporte,
			S.terminal,
			S.etd,
			S.eta,
			S.deadline_draft,
			S.deadline_carga,

			S.dt_ins				[Insert Date],
			S.Dt_Sent				[Sent Date]	
		from 
			ATL_INT.dbo.JSON_Oxiteno_updateSalesOrders S with(nolock)	
			
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		select 
			S.ID_updateSalesOrders [Internal Code],
			S.cd_pedido,
			S.numero_pedido,
			S.Num_Proc				[JOB],	
			S.booking,
			S.numero_viagem,
			S.navio,
			S.conhec_transporte,
			S.terminal,
			S.etd,
			S.eta,
			S.deadline_draft,
			S.deadline_carga,

			S.dt_ins				[Insert Date],
			S.Dt_Sent				[Sent Date]	
		from 
			ATL_INT.dbo.JSON_Oxiteno_updateSalesOrders S with(nolock)
		where 
			ID_updateSalesOrders = @ID_updateSalesOrders
	End
if @Tipo = 'N' or @Tipo = 'O'
	Begin
		select 
			S.ID_updateSalesOrders [Internal Code],
			S.cd_pedido,
			S.numero_pedido,
			S.Num_Proc				[JOB],	
			S.booking,
			S.numero_viagem,
			S.navio,
			S.conhec_transporte,
			S.terminal,
			S.etd,
			S.eta,
			S.deadline_draft,
			S.deadline_carga,

			S.dt_ins				[Insert Date],
			S.Dt_Sent				[Sent Date]	
		from 
			ATL_INT.dbo.JSON_Oxiteno_updateSalesOrders S with(nolock)
		where 
			numero_pedido = @numero_pedido
	End

if @Tipo = 'P'
	Begin
		select 
			S.ID_updateSalesOrders [Internal Code],
			S.cd_pedido,
			S.numero_pedido,
			S.Num_Proc				[JOB],	
			S.booking,
			S.numero_viagem,
			S.navio,
			S.conhec_transporte,
			S.terminal,
			S.etd,
			S.eta,
			S.deadline_draft,
			S.deadline_carga,

			S.dt_ins				[Insert Date],
			S.Dt_Sent				[Sent Date]	
		from 
			ATL_INT.dbo.JSON_Oxiteno_updateSalesOrders S with(nolock)	
		Where
			S.Dt_Sent is null		
	End

if @Tipo = 'X'
	Begin		
		select distinct
			NULL						[Internal Code],
			USO.Cd_pedido				Cd_pedido,
			USO.Numero_Pedido			numero_pedido,
			USO.Num_Proc				[JOB],	
			HOU.Booking_Number			[booking],
			HOU.Viagem					[numero_viagem],
			HOU.Vessel					[navio],
			HOU.HAWB					[conhec_transporte],
			T.Nome_Terminal				[terminal],
			(Case when isnull (HOU.Cd_Armador, 'XXX') = 'XXX' then null else HOU.ETD END) 						[etd],
			(Case when isnull (HOU.Cd_Armador, 'XXX') = 'XXX' then null  else HOU.ETA end)						[eta],
			--hou.etd,
			--hou.eta,
			HOU.Dead_line				[deadline_draft],
			HOU.Cut_Date				[deadline_carga],
			null						[Insert Date],
			null						[Sent Date]
			--hou.cd_armador [armador]
		from vwHouse_Exp HOU with(nolock)	
			join Pedido_SHIP PS with(nolock) on PS.NUm_proc = HOU.Num_Proc 
			join Pedido P with(nolock) on P.Cd_pedido = PS.Cd_pedido
			join ATL_INT.dbo.JSON_Oxiteno_SalesOrder USO with(nolock) on USO.NUm_proc = HOU.Num_Proc and USO.CD_pedido = PS.CD_pedido
			left join Terminal T with(nolock) on HOU.Cd_terminal = T.Cd_terminal					
			join Exchange EXC with(nolock) on HOU.NUm_proc COLLATE DATABASE_DEFAULT = EXC.ExcProcesso  COLLATE DATABASE_DEFAULT	
			join Pessoa_LLP LLP with(nolock) on LLP.cd_pes = HOU.cd_consig and cd_pes_grupo = 'P21128'
			join Tarefas_Processos TP15 with(nolock) on TP15.NUm_proc = HOU.Num_Proc and TP15.Id_Task = 15	
		Where
			--HOU.num_proc ='EMOXT202206001BR' and
			EXC.ExcDataAlt >= DateAdd(hour,-2,getdate())
			and (
			(	
				left(HOU.num_proc,2) in ('EO','EA') and HOU.Booking_Number is null)
				or 
				(left(HOU.num_proc,2) = 'EM'and HOU.Booking_Number is not null)
			)
			--and HOU.Booking_Number is not null	
			and TP15.Dt_conclusao is null
			--and isnull (HOU.Cd_Armador, 'XXX') <> 'XXX'
	End

if @Tipo = 'I' --usada na tela do Integrated Received
	Begin
		select 
			S.ID_updateSalesOrders [Internal Code],
			S.cd_pedido,
			S.numero_pedido,
			S.Num_Proc				[JOB],	
			S.booking,
			S.numero_viagem,
			S.navio,
			S.conhec_transporte,
			S.terminal,
			S.etd,
			S.eta,
			S.deadline_draft,
			S.deadline_carga,

			S.dt_ins				[Insert Date],
			S.Dt_Sent				[Sent Date]	
		from 
			ATL_INT.dbo.JSON_Oxiteno_updateSalesOrders S with(nolock)
		where 
			S.dt_ins > getdate() -1
	End

if @Tipo = 'T' --Testar JOB unico , descomentar o id 447747 para testar com o Cadu
	Begin
		select 
			S.ID_updateSalesOrders [Internal Code],
			S.cd_pedido,
			S.numero_pedido,
			S.Num_Proc				[JOB],	
			S.booking,
			S.numero_viagem,
			S.navio,
			S.conhec_transporte,
			S.terminal,
			S.etd,
			S.eta,
			S.deadline_draft,
			S.deadline_carga,

			S.dt_ins				[Insert Date],
			S.Dt_Sent				[Sent Date]	
		from 
			ATL_INT.dbo.JSON_Oxiteno_updateSalesOrders S with(nolock)	
		Where
			S.ID_updateSalesOrders = 447747
	End


GO
