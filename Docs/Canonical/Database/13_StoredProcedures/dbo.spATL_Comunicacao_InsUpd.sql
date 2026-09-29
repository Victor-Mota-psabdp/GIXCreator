SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spATL_Comunicacao_InsUpd]
(
	@cd_pes 		varchar(10),
	@Contato 		varchar(120),
	@Depto_Ctt		varchar(20),
	@cd_Int			varchar(3),
	@cd_area_fone	Varchar(4),
	@Num_Fone		varchar(20),
	@ramal			varchar(4),
	@Compl_Fone		varchar(40),
	@Cd_Tp_Com		varchar(3)
)
AS

set @num_Fone = right('          ' + @Num_Fone,10)

Begin Transaction
	If  exists (select cd_pes from comunicacao where cd_pes=@cd_pes and Cd_Tp_Com=@Cd_Tp_Com)
	   Begin
		Update
			Comunicacao
		Set
			Depto_Ctt=@Depto_Ctt,
			Compl_Fone=@Compl_Fone,
			Cd_Int = @cd_int,
			Cd_Area_Fone = @cd_area_fone,			
			Prefixo = replace(left(@Num_Fone,4),' ',''),
			Num_Fone = replace(right(left(@Num_Fone,10),6),' ',''),			
			ramal = @ramal,
			Contato=@contato
		Where
--			cd_pes=@cd_pes and 
--			Contato=@contato
			cd_pes=@cd_pes and 
			Cd_Tp_Com = @Cd_Tp_Com
		
			
	   End
	Else
		begin
			Insert
				Comunicacao
			(
				cd_pes,
				Cd_Tp_Com,
				Contato,
				Depto_Ctt,
				Compl_Fone,
				Cd_Int,
				Cd_Area_Fone,
				Prefixo,
				Num_Fone,
				Ramal
			)
			Values
			(
				@cd_pes,			
				@Cd_Tp_Com,
				@Contato,
				@Depto_Ctt,
				@Compl_Fone,
				@cd_int,
				@cd_area_fone,
				replace(left(@Num_Fone,4),' ',''),
				replace(right(left(@Num_Fone,10),6),' ',''),
				@Ramal
				
			)

			If @@Error  <> 0 
				Begin 
					Rollback  Transaction 
					Return -1 
				End 
			Else
				Begin 
					Commit Transaction 
					Return 1 
				End 
		end
			
commit Transaction

GO
