package main

import (
	"bytes"
	"encoding/json"
	"flag"
	"fmt"
	"io"
	"io/ioutil"
	"mime/multipart"
	"net/http"
	"os"
	"path/filepath"
)

func UploadImageToSlack(u, token, name, channels string, r io.Reader) error {
	body := &bytes.Buffer{}
	writer := multipart.NewWriter(body)
	part, err := writer.CreateFormFile("file", name)
	if err != nil {
		return err
	}
	if _, err := io.Copy(part, r); err != nil {
		return err
	}
	err = writer.WriteField("token", token)
	if err != nil {
		return err
	}
	err = writer.WriteField("channels", channels)
	if err != nil {
		return err
	}
	err = writer.Close()
	if err != nil {
		return err
	}
	req, err := http.NewRequest("POST", u, body)
	req.Header.Set("Content-Type", writer.FormDataContentType())
	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		return err
	}
	defer resp.Body.Close()
	_, err = ioutil.ReadAll(resp.Body)
	if err != nil {
		return err
	}
	return nil
}

type Tokenconf struct {
	Token   string `json:"token"`
	Channel string `json:"channel"`
}

func postimg4slack(fpath string) {
	// load json
	exe, err := os.Executable()
	cfile, err := ioutil.ReadFile(filepath.Dir(exe) + "/postimg4slack_tmi8.secret")
	if err != nil {
		fmt.Println("ERROR")
		fmt.Println(err)
		return
	}
	var config Tokenconf
	err = json.Unmarshal(cfile, &config)
	if err != nil {
		fmt.Println("ERROR")
		fmt.Println(err)
		return
	}
	token := config.Token
	channel := config.Channel

	posturl := "https://slack.com/api/files.upload"
	file, err := os.Open(fpath)
	if err != nil {
		fmt.Println("ERROR")
		fmt.Println(err)
	}
	defer file.Close()
	UploadImageToSlack(posturl, token, "filename", channel, file)
}

func main() {
	flag.String("str", "default", "string flag")
	flag.Parse()
	for idx := 0; idx < flag.NArg(); idx++ {
		postimg4slack(flag.Arg(idx))
	}
	return
}
