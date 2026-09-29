SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--insert into tipo_campo_ordem
--select 26,cd_pes_grupo,Tipo,'STO Indicator',Tab_Relacionada,Cod_Busca_PK,Campo_Exibicao,Ativo 
--from tipo_campo_ordem  where id_campo = 25
--update tipo_campo_ordem set Descr_Campo = 'STO Indicator'  where id_campo = 26
--[spATL_LayoutTXTDivisao_Sel] 'Aleatorio','Campo_Ordem',''
--[spATL_LayoutTXTDivisao_Sel] 'Aleatorio',null,null
CREATE procedure [dbo].[spATL_LayoutTXTDivisao_Sel] 
(
	@Divisao varchar(50),
	@Nome_Tp_Layout varchar(50),
	@Indicador varchar(10)
)
as
Begin
	Declare @TableTemp Table
	(
		ID int,
		[Tipo Layout] varchar(50),
		[Nome Layout] varchar(50),
		[Campo ATL]	varchar(50),
		[Indicador] varchar(50),
		[Posição]	varchar(50),
		[Tipo]	Varchar(50),
		Divisao varchar(50),
		[strValor] varchar(50)
	)

	if @Nome_Tp_Layout is null and @Indicador is null
		Begin
			select 
				CL.Divisao, 
				TL.Nome_Tp_Layout,
				isnull(LT.Tipo,'') [Indicador]
			from 
				Layout_TXTv2 LT With (Nolock)
			join Campo_Label CL With (Nolock) on CL.ID_Coluna = LT.ID_Campo and CL.Status = 1
			join Tipo_Layout TL With (Nolock) on TL.Cd_Tp_Layout = CL.Cd_Tp_Layout and TL.Status = 1
			where 
			CL.Divisao = @Divisao 
			group by 
			CL.Divisao, TL.Nome_Tp_Layout, LT.Tipo
		END
	ELSE If @Divisao <> 'Aleatorio'
		Begin
			select 
					LT.ID_Layout [ID],
					TL.Nome_Tp_Layout [Tipo Layout],
					IL.Nome_Layout [Nome Layout], 
					CL.Campo_ATL [Campo ATL], 
					Indicador, 
					LT.Posicao[Posição],
					isnull(LT.Tipo,'') [Tipo],
					Divisao, 
					'' [strValor]  
			from 
					Layout_TXTv2 LT With (Nolock)
			join Campo_Label CL With (Nolock) on CL.ID_Coluna = LT.ID_Campo and CL.Status = 1
			join Integracao_Layout IL With (Nolock) on IL.Cd_Layout = LT.Cd_Layout and IL.Status = 1
			join Tipo_Layout TL With (Nolock) on TL.Cd_Tp_Layout = CL.Cd_Tp_Layout and TL.Status = 1
			where 
				 CL.Divisao = @Divisao and TL.Nome_Tp_Layout = @Nome_Tp_Layout and isnull(Tipo,'') = @Indicador and LT.Status = 1
		End
	ELSE
		Begin
			Declare @cId_Campo int
			Declare	@cIndicador varchar(50)
			Declare @cPosicao varchar(50)
			Declare @cCampo_Busca varchar(50)
			Declare cTemp cursor for 
				Select '1'[Id_Campo],'SOD' [Indicador]	,'61-95'[Posicao]		,	''[Campo_Busca] union all
				select '2'			,'OCNT'				,'621-625'				,	'SCAC'	 union all			
				Select '3'			,'FIXO'				,'Via Integração: 304'	,	'' union all
				Select '9'			,'SLDI'				,'7-42'	,	'' union all
				Select '10'			,'SLDI'				,'147-217'	,	'' union all
				Select '11'			,'SLDI'				,'217-236'	,	'' union all
				Select '12'			,'SLDI'				,'236-253'	,	'' union all
				Select '15'			,'CINVI'			,'146-226'	,	'' union all
				Select '16'			,'PLNTI'			,'225-244'	,	'' union all
				Select '17'			,'CINVI'			,'234-253'	,	'' union all
				Select '24'			,'EQPMTI'			,'109-111'	,	''	union all
				Select '23'			,'EQPMTI'			,'111-113'	,	''	union all
				Select '25'			,'EQPMTI'			,'129-150'	,	''	union all
				Select '26'			,'NTE'				,'7-11'		,	''	union all
				Select '900'		,'SOD2'				,'10-14'				,	''
			Open cTemp
			
			Fetch next From cTemp into @cId_Campo, @cIndicador,@cPosicao,@cCampo_Busca
			While @@FETCH_STATUS=0
				Begin
					Insert @TableTemp
							select 
							LT.ID_Layout [ID],
							TL.Nome_Tp_Layout [Tipo Layout],
							IL.Nome_Layout [Nome Layout], 
							CL.Campo_ATL [Campo ATL], 
							Case When Indicador = 'FIXO' THEN 'FIXO' ELSE @cIndicador END [Indicador], 
							Case When Indicador <>'FIXO' THEN @cPosicao 
								 When Indicador = 'FIXO' and CL.Campo_ATL = 'Id_Campo' THEN convert(varchar(50),@cId_Campo)
								 ELSE LT.Posicao
							END [Posição],
							Case When CL.Campo_ATL = 'Campo_Dados' THEN convert(varchar(50),@cCampo_Busca)
							ELSE isnull(LT.Tipo,'')
							END [Tipo],
							convert(varchar(50),@cId_Campo) + '-' + Divisao [Divisao], 
							'' [strValor]
							from 
									Layout_TXTv2 LT With (Nolock)
							join Campo_Label CL With (Nolock) on CL.ID_Coluna = LT.ID_Campo and CL.Status = 1
							join Integracao_Layout IL With (Nolock) on IL.Cd_Layout = LT.Cd_Layout and IL.Status = 1
							join Tipo_Layout TL With (Nolock) on TL.Cd_Tp_Layout = CL.Cd_Tp_Layout and TL.Status = 1
							where 
								 CL.Divisao = @Divisao and TL.Nome_Tp_Layout = @Nome_Tp_Layout and isnull(Tipo,'') = @Indicador and LT.Status = 1
				Fetch next From cTemp into @cId_Campo, @cIndicador,@cPosicao,@cCampo_Busca
				End
			Select * from @TableTemp 
		End
		
End

----[spATL_LayoutTXTDivisao_Sel] 'Aleatorio','Campo_Ordem',''
----[spATL_LayoutTXTDivisao_Sel] 'Aleatorio',null,null
--ALTER procedure [dbo].[spATL_LayoutTXTDivisao_Sel] 
--(
--	@Divisao varchar(50),
--	@Nome_Tp_Layout varchar(50),
--	@Indicador varchar(10)
--)
--as
--Begin
--	Declare @TableTemp Table
--	(
--		ID int,
--		[Tipo Layout] varchar(50),
--		[Nome Layout] varchar(50),
--		[Campo ATL]	varchar(50),
--		[Indicador] varchar(50),
--		[Posição]	varchar(50),
--		[Tipo]	Varchar(50),
--		Divisao varchar(50),
--		[strValor] varchar(50)
--	)

--	if @Nome_Tp_Layout is null and @Indicador is null
--		Begin
--			select 
--				CL.Divisao, 
--				TL.Nome_Tp_Layout,
--				isnull(LT.Tipo,'') [Indicador]
--			from 
--				Layout_TXTv2 LT With (Nolock)
--			join Campo_Label CL With (Nolock) on CL.ID_Coluna = LT.ID_Campo and CL.Status = 1
--			join Tipo_Layout TL With (Nolock) on TL.Cd_Tp_Layout = CL.Cd_Tp_Layout and TL.Status = 1
--			where 
--			CL.Divisao = @Divisao 
--			group by 
--			CL.Divisao, TL.Nome_Tp_Layout, LT.Tipo
--		END
--	ELSE If @Divisao <> 'Aleatorio'
--		Begin
--			select 
--					LT.ID_Layout [ID],
--					TL.Nome_Tp_Layout [Tipo Layout],
--					IL.Nome_Layout [Nome Layout], 
--					CL.Campo_ATL [Campo ATL], 
--					Indicador, 
--					LT.Posicao[Posição],
--					isnull(LT.Tipo,'') [Tipo],
--					Divisao, 
--					'' [strValor]  
--			from 
--					Layout_TXTv2 LT With (Nolock)
--			join Campo_Label CL With (Nolock) on CL.ID_Coluna = LT.ID_Campo and CL.Status = 1
--			join Integracao_Layout IL With (Nolock) on IL.Cd_Layout = LT.Cd_Layout and IL.Status = 1
--			join Tipo_Layout TL With (Nolock) on TL.Cd_Tp_Layout = CL.Cd_Tp_Layout and TL.Status = 1
--			where 
--				 CL.Divisao = @Divisao and TL.Nome_Tp_Layout = @Nome_Tp_Layout and isnull(Tipo,'') = @Indicador and LT.Status = 1
--		End
--	ELSE
--		Begin
--			Declare @cId_Campo int
--			Declare	@cIndicador varchar(50)
--			Declare @cPosicao varchar(50)
--			Declare @cCampo_Busca varchar(50)
--			Declare cTemp cursor for 
--				Select '1'[Id_Campo],'SOD' [Indicador]	,'61-95'[Posicao]		,	''[Campo_Busca] union all
--				select '2'			,'OCNT'				,'621-625'				,	'SCAC'	 union all			
--				Select '3'			,'FIXO'				,'Via Integração: 304'	,	'' union all
--				Select '9'			,'SLDI'				,'7-42'	,	'' union all
--				Select '10'			,'SLDI'				,'147-217'	,	'' union all
--				Select '11'			,'SLDI'				,'217-236'	,	'' union all
--				Select '12'			,'SLDI'				,'236-253'	,	'' union all
--				Select '15'			,'CINVI'			,'146-226'	,	'' union all
--				Select '16'			,'PLNTI'			,'225-244'	,	'' union all
--				Select '17'			,'CINVI'			,'234-253'	,	'' union all
--				Select '24'			,'EQPMTI'			,'109-111'	,	''	union all
--				Select '23'			,'EQPMTI'			,'111-113'	,	''	union all
--				Select '25'			,'EQPMTI'			,'129-150'	,	''	union all
--				Select '900'		,'SOD2'				,'10-14'				,	''
--			Open cTemp
			
--			Fetch next From cTemp into @cId_Campo, @cIndicador,@cPosicao,@cCampo_Busca
--			While @@FETCH_STATUS=0
--				Begin
--					Insert @TableTemp
--							select 
--							LT.ID_Layout [ID],
--							TL.Nome_Tp_Layout [Tipo Layout],
--							IL.Nome_Layout [Nome Layout], 
--							CL.Campo_ATL [Campo ATL], 
--							Case When Indicador = 'FIXO' THEN 'FIXO' ELSE @cIndicador END [Indicador], 
--							Case When Indicador <>'FIXO' THEN @cPosicao 
--								 When Indicador = 'FIXO' and CL.Campo_ATL = 'Id_Campo' THEN convert(varchar(50),@cId_Campo)
--								 ELSE LT.Posicao
--							END [Posição],
--							Case When CL.Campo_ATL = 'Campo_Dados' THEN convert(varchar(50),@cCampo_Busca)
--							ELSE isnull(LT.Tipo,'')
--							END [Tipo],
--							convert(varchar(50),@cId_Campo) + '-' + Divisao [Divisao], 
--							'' [strValor]
--							from 
--									Layout_TXTv2 LT With (Nolock)
--							join Campo_Label CL With (Nolock) on CL.ID_Coluna = LT.ID_Campo and CL.Status = 1
--							join Integracao_Layout IL With (Nolock) on IL.Cd_Layout = LT.Cd_Layout and IL.Status = 1
--							join Tipo_Layout TL With (Nolock) on TL.Cd_Tp_Layout = CL.Cd_Tp_Layout and TL.Status = 1
--							where 
--								 CL.Divisao = @Divisao and TL.Nome_Tp_Layout = @Nome_Tp_Layout and isnull(Tipo,'') = @Indicador and LT.Status = 1
--				Fetch next From cTemp into @cId_Campo, @cIndicador,@cPosicao,@cCampo_Busca
--				End
--				Close cTemp
--				deallocate cTemp	
--			Select * from @TableTemp 
--		End
		
--End
GO
