SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE Procedure [dbo].[spHist_Rel]

as



select HSGData, HSDDescricao,hsgprocesso from hist_geral With(nolock)
Where (disp_cliente <> 'N' or disp_cliente is null) and (cd_origem <>'S' or cd_origem is null)





GO
