SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help vwATL_Exchange_FComex_Sel
CREATE  VIEW [dbo].[vwATL_Exchange_FComex_Sel]
AS
			select 
				 e.Exchange_id,
                 e.Num_Proc, 
				 e.Processo,
				 e.Lido_Processo,
				 e.Dt_Leitura_Processo,
				 e.Dt_Fim_Processo,
				 e.Id_Empresa [Id_Empresa],
	   		     f.Nome_Empresa ,
				 isnull(j.id_processo,0) [Id_Processo], 
 				 0 [Item_Id]
			from ATL_INT.dbo.Exchange_FComex e with(nolock)
			left join atl_int.dbo.JSON_FComex_JobReferences_Line j with(nolock)	on j.Num_Proc = e.Num_Proc
			left join atl_int.dbo.Empresa_FComex f  with(nolock)	on f.Id_Empresa = e.Id_Empresa
		

GO
