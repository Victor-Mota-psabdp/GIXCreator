SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pMIM_Del    Script Date: 17/10/2002 07:32:50 ******/
CREATE PROCEDURE pMIM_Del 
(
@Num_Proc				varchar(14)
)
 AS
	-- Parâmetros de Retorno 
	-- (-2)  Erro no processo de Exclusão 
	-- (-1) Erro de Chave
	
	If Exists(Select Num_Proc_MIM From Master_Imp_Mar Where Num_Proc_MIM = @Num_Proc)
		Begin 
			Delete From 
				Master_Imp_Mar
			Where 
				Num_proc_MIM = @Num_Proc 
			If @@RowCount <> 1 
				Return - 2
			Else
				Return 1 
		End 
	Else
		Return - 1



GO
