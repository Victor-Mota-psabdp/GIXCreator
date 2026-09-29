SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[spATL_MarcacaoPonto_InsUpd]'000067493','3','07042015','0702','020346351272','ColetaParcial-11000043.txt-070415-140415.txt'
create procedure [dbo].[spATL_MarcacaoPonto_InsUpd]
(
@NSR	varchar(9),
@Tipo_Registro	varchar(1),
@Data	varchar(8),
@Hora	varchar(4),
@PIS	varchar(12),
@Arquivo varchar(100)
)
as
Declare @ID bigint



if not exists (select ID from marcacao_ponto where PIS = @PIS and Data = @Data and Hora = @Hora)
	Begin
	set @ID = (select isnull(MAX(ID),0)+1 from marcacao_ponto)
		insert marcacao_ponto (
			ID,
			NSR,
			Tipo_Registro,
			Data,
			Hora,
			PIS,
			Arquivo,
			Dt_Ins
			)
		values(
			@ID,
			@NSR,
			@Tipo_Registro,
			@Data,
			@Hora,
			@PIS,
			@Arquivo,
			getdate()
			)
	End
else
	Begin
		update marcacao_ponto set
			NSR =@NSR,
			TIPO_REgistro = @Tipo_Registro,
			Arquivo = @Arquivo,
			Dt_Ins = getdate()
		where PIS = @PIS and Data = @Data and Hora = @Hora
			
	End
GO
