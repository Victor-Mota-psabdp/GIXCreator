SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  function fCC_IM(
				@Processo varchar(16)

)
RETURNS int

BEGIN
		Declare @Resultado int

		SET @Resultado=ISNULL((select count(item_cont_im) from container_hou_imp_mar CMM where CMM.num_proc_him=@processo),1) 

		RETURN @Resultado


END




GO
