SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pAjusteNF_Ins  
(
@Tipo_Ajuste 		VarChar(50), 
@Field_01_Ln 		Int, 
@Field_01_Cl 		Int, 
@Field_02_Ln 		Int, 
@Field_02_Cl 		Int, 
@Field_03_Ln 		Int, 
@Field_03_Cl 		Int, 
@Field_04_Ln 		Int, 
@Field_04_Cl 		Int, 
@Field_05_Ln 		Int, 
@Field_05_Cl 		Int, 
@Field_06_Ln 		Int, 
@Field_06_Cl 		Int, 
@Field_07_Ln 		Int, 
@Field_07_Cl 		Int, 
@Field_08_Ln 		Int, 
@Field_08_Cl 		Int, 
@Field_09_Ln 		Int, 
@Field_09_Cl 		Int, 
@Field_10_Ln 		Int, 	
@Field_10_Cl 		Int, 
@Field_11_Ln		Int, 
@Field_11_Cl 		Int, 
@Field_12_Ln 		Int, 	
@Field_12_Cl 		Int, 
@Field_13_Ln 		Int, 
@Field_13_Cl 		Int, 
@Field_14_Ln 		Int, 
@Field_14_Cl 		Int, 		
@Field_15_Ln 		Int, 
@Field_15_Cl 		Int, 	
@Field_16_Ln 		Int, 
@Field_16_Cl 		Int, 
@Field_17_Ln 		Int, 
@Field_17_Cl 		Int, 
@Field_18_Ln 		Int, 
@Field_18_Cl 		Int,
@Field_19_Ln 		Int, 
@Field_19_Cl 		Int, 
@Field_20_Ln 		Int, 
@Field_20_Cl 		Int,
@Field_21_Ln 		Int, 
@Field_21_Cl 		Int,
@Field_22_Ln 		Int, 
@Field_22_Cl 		Int,
@Field_23_Ln 		Int, 
@Field_23_Cl 		Int
)
AS
	Declare @Max 	Int
	Set @Max = IsNull((Select Max(Cd_Tipo_Ajuste) From Ajuste_NF) ,0) + 1
	Insert Into 
		Ajuste_NF 
	Values 
		(@Max, @Tipo_Ajuste, @Field_01_Ln, @Field_01_Cl, @Field_02_Ln, @Field_02_Cl, @Field_03_Ln, 
		@Field_03_Cl, @Field_04_Ln, @Field_04_Cl, @Field_05_Ln, @Field_05_Cl, @Field_06_Ln, 
		@Field_06_Cl, @Field_07_Ln, @Field_07_Cl, @Field_08_Ln, @Field_08_Cl, @Field_09_Ln, 
		@Field_09_Cl, @Field_10_Ln, @Field_10_Cl, @Field_11_Ln, @Field_11_Cl, @Field_12_Ln, 
		@Field_12_Cl, @Field_13_Ln, @Field_13_Cl, @Field_14_Ln, @Field_14_Cl, @Field_15_Ln, 
		@Field_15_Cl, @Field_16_Ln, @Field_16_Cl, @Field_17_Ln, @Field_17_Cl, @Field_18_Ln, 
		@Field_18_Cl, @Field_19_Ln, @Field_19_Cl, @Field_20_Ln, @Field_20_Cl, @Field_21_Ln, 
		@Field_21_Cl, @Field_22_Ln, @Field_22_Cl, @Field_23_Ln, @Field_23_Cl)

GO
