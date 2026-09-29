SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[attrep_fn_LsnSegmentToHexa] (@InputData VARBINARY(32)) RETURNS VARCHAR(64)
AS
  BEGIN
    DECLARE  @HexDigits   	CHAR(16),
             @OutputData      VARCHAR(64),
             @i           	INT,
             @InputDataLength INT

    DECLARE  @ByteInfo  	INT,
             @LeftNibble 	INT,
             @RightNibble INT

    SET @OutputData = ''

    SET @i = 1

    SET @InputDataLength = DATALENGTH(@InputData)

    SET @HexDigits = '0123456789abcdef'

    WHILE (@i <= @InputDataLength)
      BEGIN
        SET @ByteInfo = CONVERT(INT,SUBSTRING(@InputData,@i,1))
        SET @LeftNibble= FLOOR(@ByteInfo / 16)
        SET @RightNibble = @ByteInfo - (@LeftNibble* 16)
        SET @OutputData = @OutputData + SUBSTRING(@HexDigits,@LeftNibble+ 1,1) + SUBSTRING(@HexDigits,@RightNibble + 1,1)
        SET @i = @i + 1
      END

    RETURN @OutputData

  END

GO
