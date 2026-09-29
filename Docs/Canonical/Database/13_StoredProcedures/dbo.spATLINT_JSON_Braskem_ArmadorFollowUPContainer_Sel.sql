SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE procedure [dbo].[spATLINT_JSON_Braskem_ArmadorFollowUPContainer_Sel]
(
	@ID_IntegrarFollowUP			bigint,
	@ID_ArmadorFollowUPContainer	bigint,
	@Num_Proc				varchar(16),
	@Tipo					char(1)
)
as

--sp_help ATL_INT.dbo.JSON_Braskem_ArmadorFollowUPContainer

if @Tipo = 'A' or @Tipo = 'B'
	Begin
		select 		
			J.ID_IntegrarFollowUP [Internal Code],			
			J.ID_ArmadorFollowUPContainer,	
			ordem,
			UPPER(J.numero) numero,
			J.tipoContainer,	
			J.tipoSituacaoContainer			
		from 
			ATL_INT.dbo.JSON_Braskem_ArmadorFollowUPContainer J with(nolock)
			join ATL_INT.dbo.JSON_Braskem_IntegrarFollowUP JOB with(nolock) on JOB.ID_IntegrarFollowUP = J.ID_IntegrarFollowUP
			
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		select 		
			J.ID_IntegrarFollowUP [Internal Code],			
			J.ID_ArmadorFollowUPContainer,	
			ordem,
			UPPER(J.numero) numero,
			J.tipoContainer,	
			J.tipoSituacaoContainer			
		from 
			ATL_INT.dbo.JSON_Braskem_ArmadorFollowUPContainer J with(nolock)
			join ATL_INT.dbo.JSON_Braskem_IntegrarFollowUP JOB with(nolock) on JOB.ID_IntegrarFollowUP = J.ID_IntegrarFollowUP
		where 
			J.ID_IntegrarFollowUP = @ID_IntegrarFollowUP
	End
if @Tipo = 'N' or @Tipo = 'O'
	Begin
		select 		
			J.ID_IntegrarFollowUP [Internal Code],			
			J.ID_ArmadorFollowUPContainer,	
			ordem,
			UPPER(J.numero) numero,
			J.tipoContainer,	
			J.tipoSituacaoContainer			
		from 
			ATL_INT.dbo.JSON_Braskem_ArmadorFollowUPContainer J with(nolock)
			join ATL_INT.dbo.JSON_Braskem_IntegrarFollowUP JOB with(nolock) on JOB.ID_IntegrarFollowUP = J.ID_IntegrarFollowUP
		where 
			J.ID_IntegrarFollowUP = @ID_IntegrarFollowUP and J.ID_ArmadorFollowUPContainer = @ID_ArmadorFollowUPContainer
	End


if @Tipo = 'X'
	Begin
		select distinct
			NULL							[Internal Code],			
			NULL							ID_ArmadorFollowUPContainer,
			ROW_NUMBER() OVER(PARTITION BY CH.NUM_PROC_HIM ORDER BY CH.NUM_PROC_HIM ASC)	ordem,
			UPPER(REPLACE(CM.NUM_CONT_IM,'-',''))	numero,
			--TC.Nome_Tp_COnt					tipoContainer,
			DP.Cd_Dst						tipoContainer,
			TCA.Nome_Tp_Carga				tipoSituacaoContainer,
			CH.NUM_PROC_HIM					[JOB]		
		FROM dbo.CONTAINER_MAS_IMP_MAR CM WITH(NOLOCK)
		JOIN dbo.TIPO_CONTAINER TC WITH(NOLOCK) ON TC.CD_TP_CONT=CM.CD_TP_CONT
		JOIN dbo.CONTAINER_HOU_IMP_MAR CH WITH(NOLOCK) ON CH.NUM_PROC_MIM=CM.NUM_PROC_MIM AND CH.ITEM_CONT_IM=CM.ITEM_CONT_IM	
		JOIN vwHouse_Imp HOU on HOU.Num_Proc = CH.NUM_PROC_HIM 
		JOIN dbo.Tipo_Carga TCA WITH(NOLOCK) ON TCA.Cd_Tp_Carga=HOU.Tp_Carga
		left join dbo.De_Para DP WITH(NOLOCK) ON DP.Cd_Cliente='P000000438' AND DP.Cd_Tipo = '13' and DP.Cd_Org=TC.Cd_Tp_Cont
		WHERE
			CH.NUM_PROC_HIM =@Num_Proc
	End





GO
