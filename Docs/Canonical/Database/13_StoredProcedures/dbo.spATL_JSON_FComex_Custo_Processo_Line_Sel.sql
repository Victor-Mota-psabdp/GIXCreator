SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_JSON_FComex_Custo_Processo_Line_Sel]

	@Id_Processo [bigint],
	@Tipo varchar(1)	   	  
AS

/*
- A todos os registros 
- C registro unico 

*/


if @Tipo = 'A'

			Begin
				Select
				     [Id_Processo],
					 [Cd_Tp_Tx],
					 [Valor],
					 [Dt_Rateio]
                From ATL_INT.dbo.JSON_FComex_Custo_Processo_Line
				Order by Id_Processo
			End
if @Tipo = 'C'

			Begin
				Select					
                     [Id_Processo],
					 [Cd_Tp_Tx],
					 [Valor],
					 [Dt_Rateio]
                From ATL_INT.dbo.JSON_FComex_Custo_Processo_Line
				Where
					Id_Processo = @Id_Processo 	
			End
GO
