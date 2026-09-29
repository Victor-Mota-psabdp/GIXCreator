SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Pessoa
CREATE procedure [dbo].[spATL_Pessoa_Del]
(
	@Cd_Pes varchar(10)
)
as
if exists(select Cd_Pes from Pessoa where Cd_Pes= @Cd_Pes and Desat_Pes = 'N')
	BEGIN
		update Pessoa set Desat_Pes ='S' where Cd_Pes= @Cd_Pes
	END

GO
