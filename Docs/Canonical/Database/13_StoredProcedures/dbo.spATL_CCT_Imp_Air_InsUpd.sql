SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_CCT_Imp_Air_InsUpd]
(
	@ID			bigint,
	@Num_Proc	varchar(16),
	@FileType	varchar(25),
	@HAWB		varchar(11),	
	@MAWB		varchar(25),
	@Dt_Ins		datetime,
	@Dt_Sent	datetime,
	@XML_Sent	xml,
	@File_Name	varchar(100),
	@MessageHeaderDocument_ID	varchar(50),
	@XML_Return	xml,
	@ProtocolNumber varchar(25),
	@Status		varchar(25),
	@CPF		varchar(25),
	@CNPJ		varchar(25),
	@ErrorList	varchar(MAX)
)

AS
BEGIN
--Exceção(try/CATCH)
--Transação
--sp_help CCT_Imp_Air
	BEGIN TRY
	
		if exists(select ID from CCT_Imp_Air where Num_Proc = @Num_Proc and [FileType] = @FileType)
			BEGIN
				Update
					CCT_Imp_Air
				set
					FileType=@FileType,	HAWB=@HAWB,MAWB=@MAWB,Dt_Ins=@Dt_Ins,Dt_Sent=@Dt_Sent,
					XML_Sent=@XML_Sent,[File_Name]=@File_Name,MessageHeaderDocument_ID=@MessageHeaderDocument_ID,
					XML_Return=@XML_Return,ProtocolNumber=@ProtocolNumber,[Status]=@Status,
					CPF=@CPF,CNPJ=@CNPJ,ErrorList=@ErrorList
				where
					Num_Proc = @Num_Proc
					and [FileType] = @FileType
			End
		Else	
			BEGIN
				Insert CCT_Imp_Air 
				(
					Num_Proc,FileType,HAWB,MAWB,Dt_Ins,Dt_Sent,XML_Sent,[File_Name],MessageHeaderDocument_ID,
					XML_Return,ProtocolNumber,[Status],CPF,CNPJ,ErrorList
				)
				Values
				(
					@Num_Proc,@FileType,@HAWB,@MAWB,@Dt_Ins,@Dt_Sent,@XML_Sent,@File_Name,@MessageHeaderDocument_ID
					,@XML_Return,@ProtocolNumber,@Status,@CPF,@CNPJ,@ErrorList
				)			
			END	
	
		Select @ID as Retorno;		
		
		COMMIT TRAN
	END TRY

	BEGIN CATCH
		ROLLBACK TRAN
		SELECT ERROR_MESSAGE() as Retorno;

	END CATCH	

END

GO
