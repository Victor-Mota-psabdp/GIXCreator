SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spBusca_PO_IMP_PDF2ATL_Sel]--'4T6932','OXI'
(
	@Documento varchar(50),
	@cd_grupo varchar(3)
)
as
		select Num_Proc_HIA Processo from PO_HIA  with(nolock) 
			where Numero_PO_HIA=@Documento and ID_DC=3
			and SUBSTRING(Num_Proc_HIA, 3,3) = @cd_grupo
		union all
		select Num_Proc_HIM  Processo from PO_HIM with(nolock)  
			where Numero_PO_HIM= @Documento and ID_DC=3
			and SUBSTRING(Num_Proc_HIM, 3,3) = @cd_grupo
		union all
		select Num_Proc_HIO Processo  from PO_HIO with(nolock)  
			where Numero_PO_HIO=@Documento and ID_DC=3
			and SUBSTRING(Num_Proc_HIO, 3,3) = @cd_grupo
	
OPTION(HASH JOIN)
GO
