SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spDemurrageATLDet_InsUpd]

		@Processo		VarChar(16),
		@Fatura			Char(1),
		@Container		VarChar(25),
		@Tipo_Container		VarChar(25),
		@Dt_Devolucao		VarChar(10),
		@T_Geral		Int,
		@F_Time			Int,
		@D_BDP			Int,
		@D_Cobrados		Int,
		@T_Diaria		float,
		@T_Pagar		float,
		@T_Diaria2		float,
		@T_Diaria3		float,
		@D_1Periodo		int,
		@D_2periodo		Int,
		@D_3periodo		Int
		

AS
	if not exists (select processo from demurrage_ATL_det where processo=@processo and fatura=@fatura AND CONTAINER=@CONTAINER)
		BEGIN
			insert Demurrage_ATL_Det
				(
				Processo,
				Fatura,
				Container,
				Tipo_Container,
				Dt_Devolucao,
				T_Geral,
				F_Time,
				D_BDP,
				D_Cobrados,
				T_Diaria,
				T_Pagar,
				T_diaria2,
				T_diaria3,
				D_1Periodo,
				D_2Periodo,
				D_3Periodo
				)
			Values
				(
				@Processo,
				@Fatura,
				@Container,
				@Tipo_Container,
				@Dt_Devolucao,
				@T_Geral,
				@F_Time,
				@D_BDP,
				@D_Cobrados,
				@T_Diaria,
				@T_Pagar,
				@T_Diaria2,
				@T_Diaria3,
				@D_1Periodo,
				@D_2periodo,
				@D_3periodo
				)
		end
		else
			UPDATE Demurrage_ATL_Det
		
				SET
					Tipo_Container=@Tipo_container,
					Dt_Devolucao=@Dt_Devolucao,
					T_Geral=@T_Geral,
					F_Time=@F_Time,
					D_BDP=@D_BDP,
					D_Cobrados=@D_Cobrados,
					T_Diaria=@T_Diaria,
					T_Pagar=@T_Pagar,
					T_diaria2 = @T_Diaria2,
					T_diaria3 = @T_Diaria3,
					D_1Periodo = @D_1Periodo,
					D_2Periodo = @D_2periodo,
					D_3Periodo = @D_3periodo
				WHERE
					Processo=@processo and fatura=@fatura and container=@container



GO
