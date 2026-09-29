SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Base_Nota_Fiscal_QR_Code
--alter table [dbo].[Base_Nota_Fiscal_QR_Code] add [Used] BIT NULL
CREATE PROCEDURE [dbo].[spATL_Base_Nota_Fiscal_QR_Code_InsUpd]

		@Id				int,
		@Imagem			IMAGE,
		@QRcode_Url		varchar(MAX),
		@Nota_Fiscal	varchar(10),
		@Ref_Acesso		char(1),
		@Dt_Ins			datetime,
		@Cd_Usuario		varchar(10),
		@Status			bit,
		@Used			bit

AS


Begin Transaction

	If  exists (select ID from Base_Nota_Fiscal_QR_Code with(nolock) where 
		Nota_Fiscal = @Nota_Fiscal and @Ref_Acesso= @Ref_Acesso)
		--ID=@ID)
		Begin
			Update
				Base_Nota_Fiscal_QR_Code
			Set
				Imagem = @Imagem,QRcode_Url=@QRcode_Url,Nota_Fiscal=@Nota_Fiscal,
				Ref_Acesso=@Ref_Acesso,Dt_Ins=@Dt_Ins,Cd_Usuario=@Cd_Usuario,
				Status=@Status,Used=@Used
			Where
				Nota_Fiscal = @Nota_Fiscal and @Ref_Acesso= @Ref_Acesso
		End
	Else
		Insert Base_Nota_Fiscal_QR_Code
			(Imagem,QRcode_Url,Nota_Fiscal,Ref_Acesso,Dt_Ins,Cd_Usuario,Status,Used)
		Values
			(@Imagem,@QRcode_Url,@Nota_Fiscal,@Ref_Acesso,@Dt_Ins,@Cd_Usuario,@Status,@Used)
	

Commit Transaction

GO
