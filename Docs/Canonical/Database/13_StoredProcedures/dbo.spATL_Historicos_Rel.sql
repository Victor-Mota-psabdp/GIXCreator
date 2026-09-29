SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- [spATL_Historicos_Rel] 'IAVPF201104002BR'

CREATE procedure [dbo].[spATL_Historicos_Rel]
(
	@JOB varchar(16)
)

as

declare @Tab table ([Rank] int, [ATL System] varchar(20), [ ] varchar(max))

Begin 
	insert @Tab
		select 0,'Processo:', @JOB

		UNION select 1,'Ref. Cliente:', dbo.fBusca_Docs_PO_Modal(@JOB,1)

		UNION select 2,'',''

		UNION select 3,'Data','Históricos'
End

Begin
	insert @Tab
		select rank() OVER (ORDER BY HSGData) +3 as rank,
			left(convert(char, HSGData, 103),10), HSDDescricao Historico
		from
			hist_geral with(nolock)
		where
			hsgprocesso = @JOB
			and (cd_origem='U' or cd_tp_ocor=55)
		order by
			HSGData
End

select [ATL System], [ ] from @Tab
GO
