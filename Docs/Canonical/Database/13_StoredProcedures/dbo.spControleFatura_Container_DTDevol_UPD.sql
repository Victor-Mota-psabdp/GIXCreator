SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Update na dt devol do conteiner

CREATE procedure [dbo].[spControleFatura_Container_DTDevol_UPD]--'IMATL201109005BR','CCRU194815-4','18/10/2012'
(	
	@JOb varchar(16),
	@container varchar(12),
	@dt_devol_im varchar(10)	

)
AS

Begin Transaction
		Begin
			update container_mas_imp_mar set dt_devol_im =@dt_devol_im from container_mas_imp_mar MAS
				join Container_Hou_Imp_Mar HOU on MAS.Num_Proc_MIM = HOU.Num_Proc_MIM and MAS.Item_Cont_IM = HOU.Item_Cont_IM 
			where num_proc_him = @JOb and Num_cont_im = @container
		End

Commit Transaction
GO
