SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[spGIX2ATL_Smart_XML_Sel]'11'
CREATE procedure [dbo].[spGIX2ATL_Smart_XML_Sel]--'11'
(
	 @SystemCode BIGINT
)
as
if @SystemCode = '11'
	BEGIN
		select 
			Smart_XML.ID_Smart		[ID_Smart],
			Smart_XML.Num_Proc		[Num_Proc],
			Smart_XML.XML_DOC		[XML_DOC],
			Smart_XML.Nome_Arquivo	[Nome_Arquivo],
			Smart_XML.Dt_Ins		[Dt_Ins],	
			Smart_XML.Dt_Envio		[Dt_Envio],
			L.Nome_Local,
			P.Nome_Pais
			--min(Dt_Envio) Dt_Envio 
		from 
			ATL_INT.DBO.Smart_XML Smart_XML with(nolock)
				join vwHouse_Exp HOU  with(nolock) on HOU.Num_Proc = Smart_XML.Num_Proc
				join Localidade L  with(nolock) on L.Cd_Local = HOU.Cd_Dst
				join Pais P with(nolock) on P.Cd_Pais = L.Cd_Pais
			where 
					--CONVERT(datetime,HOU.dt_emis,103) > GETDATE() -30	and 
					(
						Nome_Pais like 'Argenti%' 
							OR 
						Nome_Pais like 'Chile%' 
						--	OR 
						--Nome_Pais like 'BRA%IL%'
					)
						--desabilitei o brazil, pois tem job com destino br e br
					--and dt_envio >=getdate()-0.041666667
					and Dt_Envio > DATEADD(HOUR, -5, GETDATE())
					--and	dt_envio > GETDATE() -5		
		
			order by 
				Dt_Envio
	END

/*
--[spGIX2ATL_Smart_XML_Sel]'11'
ALTER procedure [dbo].[spGIX2ATL_Smart_XML_Sel]--'11'
(
	 @SystemCode BIGINT
)
as
if @SystemCode = '11'
	begin
		select 
			ID_Smart,Num_Proc,XML_DOC,Nome_Arquivo,
			Dt_Ins,	Dt_Envio
			--min(Dt_Envio) Dt_Envio 
		from 
			Smart_XML with(nolock)
		where
			Num_Proc in
			(
				select Num_Proc from vwHouse_Exp H with(nolock)
					join Localidade L  with(nolock) on L.Cd_Local = h.Cd_Dst
					join Pais P with(nolock) on P.Cd_Pais = L.Cd_Pais
				where 
					CONVERT(datetime,h.dt_emis,103) > GETDATE() -20
					and (Nome_Pais like 'Argenti%' or Nome_Pais like 'Chile%'
					OR Nome_Pais like 'BRA%IL%')
					--and (h.Num_Proc like '%EM%' OR h.Num_Proc like	'%EA%')
					and (h.Num_Proc like '%EO%')
			)
		and dt_envio > getdate() -120
		--group by 
		--	ID_Smart,
		--	Num_Proc,
		--	XML_DOC,
		--	Nome_Arquivo,
		--	Dt_Ins
		order by Dt_Envio
	end
	
	*/
GO
