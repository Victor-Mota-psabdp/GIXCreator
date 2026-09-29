SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spATL_Alerta_Email_Doc_Automatico_ALL_Sel 'Envio do pré-alerta','GRUPO EXXON','EXXONMOBIL - 3349C'
CREATE procedure [dbo].[spATL_Alerta_Email_Doc_Automatico_ALL_Sel](

	@NomeTask		as varchar(50),
	@GroupName		as varchar(50),
	@ClientName		as varchar(50),
	@Modal			as varchar(50),
	@TipoCarga		as varchar(50),
	@Origem			as varchar(50),
	@Destino		as varchar(50),
	@Ordem			as varchar(50),
	@Transportador	as varchar(50),
	@Terminal		as varchar(50)
)	
AS

if @GroupName = ''
	set @GroupName = '%'
	
if @ClientName = ''
	set @ClientName = '%'
	
if @Modal = ''
	set @Modal = '%'
	
if @TipoCarga = ''
	set @TipoCarga = '%'

if @Origem = ''
	set @Origem = '%'
	
if @Destino = ''
	set @Destino = '%'
	
if @Ordem = ''
	set @Ordem = '%'

if @Transportador = ''
	set @Transportador = '%'
	
if @Terminal = ''
	set @Terminal = '%'
	

	Select 
		A.ID					[ID],
		Nome_Task				[Task Name],
		(case when A.Cd_Pes_Grupo = 'ALL' then 'ALL GROUPS' else
			P.Apelido end)		[Group Name],		
		--P.Apelido				[Group Name],
		(case when A.cd_pes = 'ALL' then 'ALL Clients' else
			PP.Apelido end)		[Client Name],
		Modal					[Modal],
		Dias					[Days],
		ResponderPara			[Reply to:],
		Emails					[Sent To:],
		CopyBDP					[Copy To:],
		Doc_Anexos				[Documents Yes],
		Doc_Anexos_Nao			[Documents No],	
		Assunto					[Subject],
		Mensagem				[Body],			
		A.Dt_Ins					[Creation Date],
		Nome_Usuario			[User],
		A.Ativo,
		Email_do_CompanyRegister,
		(case when A.cd_tp_carga = 0 or A.cd_tp_carga IS null
			then 'ALL Types'
		else
			Nome_tp_Carga end) [TypeOfCargo],
		(case when A.cd_org = 'ALL' then 'ALL' else
			Org.Nome_Local end) [Origin],
		(case when A.cd_dst = 'ALL' then 'ALL' else
			Dst.Nome_Local end) [Destination],
			
		[StandardForms],
		TP.cd_tp_pedido + ' - ' + TP.nome_tp_pedido [Order Type],
		Email_do_Agente_Consolidado,
		(case when A.cd_transportadora = 'ALL' then 'ALL Inland Trucker' else
			T.Apelido end)		[Inland Trucker],
		CopyEmail				[CopyEmail],
		(case when A.cd_terminal = 'ALL' then 'ALL TERMINALS' else
			TE.Nome_Terminal end)		[Terminal],
		Zip				
	from 
		Alerta_Email_Doc_Automatico A
		LEFT join Pessoa P on P.Cd_Pes = A.cd_pes_grupo
		join Usuario U on U.Cd_Usuario = A.Cd_Usuario
		left join tipo_carga TC on TC.Cd_Tp_Carga = A.Cd_Tp_Carga
		left join Localidade Org on Org.Cd_Local = A.cd_org
		left join Localidade Dst on Dst.Cd_Local = A.cd_dst
		left join Tipo_pedido TP on TP.Cd_tp_Pedido = A.Cd_tp_Pedido
		left join Pessoa PP on PP.Cd_Pes = A.Cd_Pes
		left join Pessoa T on T.Cd_Pes = A.cd_transportadora 
		left join Terminal TE on TE.Cd_Terminal = A.Cd_Terminal
	where
		A.Nome_Task = @NomeTask
			--and isnull(P.Apelido,'') like @GroupName
		and 
		(
			(@GroupName= 'ALL GROUPS' and isnull(P.Apelido,'') <> 'ALL GROUPS')
			or 
			(isnull(P.Apelido,'') like @GroupName)
		)	
		
	
		--and isnull(PP.Apelido,'') like @ClientName
		and 
		(
			(@ClientName= 'ALL Clients' and isnull(PP.Apelido,'') <> 'ALL Clients')
			or 
			(isnull(PP.Apelido,'') like @ClientName)
		)	
		
		and isnull(A.Modal,'') like @Modal	
		
		--and isnull(TC.Nome_tp_Carga,'') like @TipoCarga		
		and 
		(
			(@TipoCarga= 'ALL Types' and isnull(TC.Nome_tp_Carga,'') <> 'ALL Types')
			or 
			(isnull(TC.Nome_tp_Carga,'') like @TipoCarga)
		)
		
		--and isnull(ORG.Nome_Local,'') like @Origem
		and 
		(
			(@Origem= 'ALL' and isnull(ORG.Nome_Local,'') <> 'ALL')
			or 
			(isnull(ORG.Nome_Local,'') like @Origem)
		)
		
		--and isnull(DST.Nome_Local,'') like @Destino
		and 
		(
			(@Destino= 'ALL' and isnull(DST.Nome_Local,'') <> 'ALL')
			or 
			(isnull(DST.Nome_Local,'') like @Destino)
		)
		
		--and isnull(TP.cd_tp_pedido + ' - ' + TP.nome_tp_pedido,'') like @Ordem
		and 
		(
			(@Ordem= '1 - All' and isnull(TP.cd_tp_pedido + ' - ' + TP.nome_tp_pedido,'') <> '1 - All')
			or 
			(isnull(TP.cd_tp_pedido + ' - ' + TP.nome_tp_pedido,'') like @Ordem)
		)
		
		--and isnull(T.Apelido,'') like @Transportador
		and 
		(
			(@Transportador= 'ALL Inland Trucker' and isnull(T.Apelido,'') <> 'ALL Inland Trucker')
			or 
			(isnull(T.Apelido,'') like @Transportador)
		)
		
		--and isnull(TE.Nome_Terminal,'') like @Terminal
		and 
		(
			(@Terminal= 'ALL TERMINALS' and isnull(TE.Nome_Terminal,'') <> 'ALL TERMINALS')
			or 
			(isnull(TE.Nome_Terminal,'') like @Terminal)
		)
			
	order by 
		A.ID,Nome_Task,P.Apelido		
GO
